"""
Module: generate_inventory.py
Description: Generates the Fact_Inventory table by taking a snapshot of stock 
             balances for every product across all 5 active branches. 
             Simulates real-world retail scenarios including positive stock, 
             zero stock (out-of-stock), and negative stock (receiving delays/errors).
"""

import pandas as pd
import numpy as np
import os
import random
from typing import List, Dict, Any

# --- Configuration Constants ---
DATA_DIR = "./data_source/"
PRODUCTS_FILE = "dim_products.csv"
INVENTORY_FILE = "fact_inventory.csv"

# Define the 5 specific hypermarket branches
BRANCHES = [
    {"branch_id": 1, "branch_name": "Nasr City"},
    {"branch_id": 2, "branch_name": "Al-Zagazig"},
    {"branch_id": 3, "branch_name": "Alexandria"},
    {"branch_id": 4, "branch_name": "Tanta"},
    {"branch_id": 5, "branch_name": "Maadi"}
]

def load_products_dimension() -> pd.DataFrame:
    """
    Loads the previously generated Dim_Products to ensure accurate 
    product mapping (Item Code, Name, Cost, Pieces).
    """
    file_path = os.path.join(DATA_DIR, PRODUCTS_FILE)
    if not os.path.exists(file_path):
        raise FileNotFoundError(f" Error: {PRODUCTS_FILE} not found. Please generate products first.")
    
    return pd.read_csv(file_path)

def generate_inventory_snapshot(df_products: pd.DataFrame) -> List[Dict[str, Any]]:
    """
    Iterates through all branches and products to generate a complete inventory 
    snapshot. Applies statistical probabilities to simulate realistic stock levels.
    
    Distribution logic:
    - 75% Positive stock (Normal operation)
    - 15% Zero stock (Out of stock / Sold out)
    - 10% Negative stock (System errors, receiving delays)
    """
    inventory_data: List[Dict[str, Any]] = []
    
    # Convert DataFrame to a list of dictionaries for faster iteration
    products_list = df_products.to_dict('records')
    
    for branch in BRANCHES:
        for prod in products_list:
            
            # Determine the status of the stock level based on probabilities
            stock_status = np.random.choice(
                ['positive', 'zero', 'negative'], 
                p=[0.75, 0.15, 0.10]
            )
            
            # Adjust quantities based on whether the item is a single piece or a bulk carton
            is_carton = str(prod.get('peices', 1)) != '1'
            
            qty_on_hand = 0
            
            if stock_status == 'positive':
                # Cartons have lower stock counts compared to single pieces
                if is_carton:
                    qty_on_hand = random.randint(5, 50)
                else:
                    qty_on_hand = random.randint(15, 300)
                    
            elif stock_status == 'negative':
                # Negative balances are usually small
                qty_on_hand = random.randint(-15, -1)
                
            elif stock_status == 'zero':
                qty_on_hand = 0
                
            # Calculate inventory valuation (Financial impact)
            # Negative stock technically creates a negative valuation liability 
            unit_cost = float(prod['costprice'])
            total_cost_value = round(qty_on_hand * unit_cost, 2)
            
            inventory_data.append({
                "snapshot_date": pd.Timestamp.now().strftime("%Y-%m-%d"),
                "branch_id": branch['branch_id'],
                "branch_name": branch['branch_name'],
                "department_id": prod['department'],
                "itemean": str(prod['itemean']).zfill(8),
                "barcode": prod['barcode'],
                "item_name": prod['a_name'],
                "qty_on_hand": qty_on_hand,
                "unit_cost": unit_cost,
                "total_cost_value": total_cost_value,
                "stock_status": stock_status.capitalize()
            })
            
    return inventory_data

def save_to_csv(data: List[Dict[str, Any]], output_dir: str, file_name: str) -> None:
    """
    Exports the generated inventory snapshot to a CSV file.
    """
    os.makedirs(output_dir, exist_ok=True)
    file_path = os.path.join(output_dir, file_name)
    
    df_inventory = pd.DataFrame(data)
    df_inventory.to_csv(file_path, index=False, encoding='utf-8-sig')
    
    print(f" Success! Generated {len(df_inventory)} inventory records across {len(BRANCHES)} branches.")
    
    # Print a quick analytical summary of the generated data
    print("\n Inventory Generation Summary:")
    print(df_inventory['stock_status'].value_counts())
    print(f" Total Positive Inventory Valuation: {df_inventory[df_inventory['qty_on_hand'] > 0]['total_cost_value'].sum():,.2f} EGP")
    
    print(f"\n File saved to: {file_path}")

if __name__ == "__main__":
    print("Loading product dimension for accurate item mapping...")
    try:
        df_products = load_products_dimension()
        print("Starting realistic inventory snapshot generation...")
        inventory_data = generate_inventory_snapshot(df_products)
        save_to_csv(inventory_data, DATA_DIR, INVENTORY_FILE)
    except Exception as e:
        print(f"Execution Error: {e}")