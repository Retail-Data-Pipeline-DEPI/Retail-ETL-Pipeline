"""
Module: generate_sales.py
Description: Generates a highly realistic Fact Table for sales (Fact_Sales).
             It reads the actual products from dim_products.csv to ensure 
             price and code integrity. It distributes sales across 5 specific 
             branches with varying realistic volumes and return rates.
"""

import pandas as pd
import numpy as np
from faker import Faker
import random
import os
from datetime import datetime, timedelta
from typing import List, Dict, Any

# --- Configuration Constants ---
DATA_DIR = "./data_source/"
PRODUCTS_FILE = "dim_products.csv"
SALES_FILE = "fact_sales.csv"
NUM_TRANSACTIONS = 5000  # عدد حركات البيع المطلوب توليدها

# Faker setp
fake = Faker()

# Identifying branches with different sales volumes:

BRANCHES = [
    {"branch_id": 1, "branch_name": "Nasr City", "weight": 0.35},
    {"branch_id": 2, "branch_name": "Al-Zagazig", "weight": 0.25},
    {"branch_id": 3, "branch_name": "Alexandria", "weight": 0.20},
    {"branch_id": 4, "branch_name": "Tanta", "weight": 0.10},
    {"branch_id": 5, "branch_name": "Maadi", "weight": 0.10}
]

def load_products_dimension() -> pd.DataFrame:
    """
    Loads the previously generated Dim_Products.
    Raises an error if the file does not exist.
    """
    file_path = os.path.join(DATA_DIR, PRODUCTS_FILE)
    if not os.path.exists(file_path):
        raise FileNotFoundError(f" Error: {PRODUCTS_FILE} not found. Please run the products generator first.")
    
    return pd.read_csv(file_path)

def generate_fact_sales(df_products: pd.DataFrame, num_rows: int) -> List[Dict[str, Any]]:
    """
    Generates realistic sales transactions based on actual product dimensions.
    """
    sales_data: List[Dict[str, Any]] = []
    
    # Transforming products DataFrame to a list of dictionaries for faster access and weighted sampling
    products_list = df_products.to_dict('records')
    
    # Setup weights to simulate that products sold by piece are more popular than those sold by carton
    # Products sold by piece (peices=1) get a higher weight (e.g., 10) compared to those sold by carton (peices=0)
    product_weights = [10.0 if str(p['peices']) == '1' else 1.0 for p in products_list]
    # (Probabilities)
    total_weight = sum(product_weights)
    product_probs = [w / total_weight for w in product_weights]
    


    #Prepare branches Probabilities for sampling
    branch_ids = [b['branch_id'] for b in BRANCHES]
    branch_probs = [b['weight'] for b in BRANCHES]
    
    start_date = datetime.now() - timedelta(days=90) # Sales for 3 months
    
    for i in range(1, num_rows + 1):
        # 1. choose the branch and the date
        branch_id = np.random.choice(branch_ids, p=branch_probs)
        trans_date = fake.date_time_between(start_date=start_date, end_date='now')
        
        # 2. choose the product based on its popularity (pieces are more likely to be sold than cartons)
        prod = np.random.choice(products_list, p=product_probs)
        
        # 3. Simulate quantity sold (1-5 for pieces, 1-2 for cartons)
        qty_sold = random.randint(1, 5) if str(prod['peices']) == '1' else random.randint(1, 2)
        
        # 4. Simulate returns (10% chance of return, with quantity between 1 and qty_sold)
        return_qty = 0
        if random.random() < 0.10: 
            return_qty = random.randint(1, qty_sold)
            
        # 5. Financial calculations (based on actual prices from the products dimension)
        net_qty = qty_sold - return_qty
        unit_price = float(prod['retailprice'])
        unit_cost = float(prod['costprice'])
        
        total_sales_value = round(qty_sold * unit_price, 2)
        total_return_value = round(return_qty * unit_price, 2)
        net_sales = round(net_qty * unit_price, 2)
        net_cost = round(net_qty * unit_cost, 2)
        profit_amount = round(net_sales - net_cost, 2)
        
        sales_data.append({
            "transaction_id": f"TRX-{trans_date.strftime('%Y%m%d')}-{i:05d}",
            "transaction_date": trans_date.strftime("%Y-%m-%d %H:%M:%S"),
            "branch_id": branch_id,
            "itemean": str(prod['itemean']).zfill(8), # كود الصنف للربط
            "barcode": prod['barcode'],
            "qty_sold": qty_sold,
            "qty_returned": return_qty,
            "net_qty": net_qty,
            "unit_price": unit_price,
            "unit_cost": unit_cost,
            "total_sales_value": total_sales_value,
            "total_return_value": total_return_value,
            "net_sales_value": net_sales,
            "net_cost_value": net_cost,
            "profit_amount": profit_amount
        })
        
    return sales_data

def save_to_csv(data: List[Dict[str, Any]], output_dir: str, file_name: str) -> None:
    """Exports the generated sales data to a CSV file."""
    os.makedirs(output_dir, exist_ok=True)
    file_path = os.path.join(output_dir, file_name)
    
    df_sales = pd.DataFrame(data)
    # Sort by transaction date to ensure realistic time sequence
    df_sales = df_sales.sort_values(by='transaction_date')
    df_sales.to_csv(file_path, index=False, encoding='utf-8-sig')
    
    print(f"Success! Generated {len(df_sales)} realistic sales transactions.")
    print(f" Total Net Sales Simulated: {df_sales['net_sales_value'].sum():,.2f} EGP")
    print(f" File saved to: {file_path}")

if __name__ == "__main__":
    print("Loading products dimension...")
    try:
        df_products = load_products_dimension()
        print("Starting realistic sales fact generation...")
        sales_data = generate_fact_sales(df_products, NUM_TRANSACTIONS)
        save_to_csv(sales_data, DATA_DIR, SALES_FILE)
    except Exception as e:
        print(e)