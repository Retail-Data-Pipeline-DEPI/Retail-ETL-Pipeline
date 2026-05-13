"""
Module: generate_products.py
Description: Generates a comprehensive synthetic dimension table for products 
             (Dim_Products) mapped to the hypermarket hierarchy departments.
             Includes a massively diversified item list (Brands, Sizes, Weights).
"""

import pandas as pd
import os
import random
from typing import List, Dict, Any

# --- Configuration Constants ---
OUTPUT_DIR = "./data_source/"
FILE_NAME = "dim_products.csv"
STARTING_ITEM_CODE = 3552

def get_base_items_mapping() -> Dict[int, List[Dict[str, Any]]]:
    """
    Returns a highly diversified dictionary mapping department IDs to their base items.
    Prices are in EGP and reflect realistic market variations based on brand and size.
    """
    return {
        # --- 1001: Fresh Meat (لحوم طازجة) ---
        1001: [
            {"name": "لحم بقري مكعبات بلدي 1 كجم", "cost": 380.0, "retail": 420.0, "has_carton": False},
            {"name": "كباب حلة طازج 1 كجم", "cost": 400.0, "retail": 450.0, "has_carton": False},
            {"name": "موزة بقري بلدي 1 كجم", "cost": 390.0, "retail": 435.0, "has_carton": False},
            {"name": "ستيك انتركوت طازج 1 كجم", "cost": 420.0, "retail": 480.0, "has_carton": False},
        ],
        
        # --- 1302: Yogurt (زبادي) ---
        1302: [
            {"name": "زبادي جهينة طبيعي 105جم", "cost": 5.5, "retail": 7.0, "has_carton": True},
            {"name": "زبادي المراعي لايت 105جم", "cost": 5.5, "retail": 7.0, "has_carton": True},
            {"name": "زبادي دانون بالفراولة 100جم", "cost": 6.5, "retail": 8.0, "has_carton": True},
            {"name": "زبادي نستله يوناني سادة 170جم", "cost": 22.0, "retail": 28.0, "has_carton": True},
            {"name": "زبادي لبنيتا عائلي 3 كجم", "cost": 110.0, "retail": 135.0, "has_carton": False},
        ],

        # --- 1303: Milk (حليب) ---
        1303: [
            {"name": "حليب جهينة كامل الدسم 1 لتر", "cost": 35.0, "retail": 42.0, "has_carton": True},
            {"name": "حليب المراعي خالي الدسم 1.5 لتر", "cost": 50.0, "retail": 60.0, "has_carton": True},
            {"name": "حليب لمار بالشوكولاتة 200 مل", "cost": 9.0, "retail": 12.0, "has_carton": True},
            {"name": "حليب بخيره كيس 500 مل", "cost": 16.0, "retail": 20.0, "has_carton": True},
        ],

        # --- 2001: Rice (أرز) ---
        2001: [
            {"name": "أرز الضحى حبة عريضة 1 كجم", "cost": 32.0, "retail": 38.0, "has_carton": True},
            {"name": "أرز الساعة 5 كجم", "cost": 150.0, "retail": 180.0, "has_carton": True},
            {"name": "أرز المطبخ 1 كجم", "cost": 29.0, "retail": 34.0, "has_carton": True},
            {"name": "أرز زمزم بسمتي هندي 1 كجم", "cost": 85.0, "retail": 105.0, "has_carton": True},
        ],

        # --- 2002: Pasta (مكرونة) ---
        2002: [
            {"name": "مكرونة الملكة مرمرية 400جم", "cost": 11.0, "retail": 14.0, "has_carton": True},
            {"name": "مكرونة إيطاليانو قلم 400جم", "cost": 16.0, "retail": 20.0, "has_carton": True},
            {"name": "مكرونة حواء اسباجتي 500جم", "cost": 14.0, "retail": 17.5, "has_carton": True},
            {"name": "مكرونة ريجينا فيونكة 400جم", "cost": 18.0, "retail": 23.0, "has_carton": True},
        ],

        # --- 2102: Corn & Sunflower Oil (زيت ذرة وعباد) ---
        2102: [
            {"name": "زيت عافية ذرة 800 مل", "cost": 75.0, "retail": 88.0, "has_carton": True},
            {"name": "زيت كريستال عباد 1.6 لتر", "cost": 135.0, "retail": 155.0, "has_carton": True},
            {"name": "زيت قلية خليط 700 مل", "cost": 45.0, "retail": 55.0, "has_carton": True},
            {"name": "زيت سلايت ذرة 2.25 لتر", "cost": 210.0, "retail": 245.0, "has_carton": True},
        ],

        # --- 2201: Canned Tuna (تونة) ---
        2201: [
            {"name": "تونة صن شاين قطع 185جم", "cost": 50.0, "retail": 65.0, "has_carton": True},
            {"name": "تونة تونة ماكيريل 140جم", "cost": 35.0, "retail": 45.0, "has_carton": True},
            {"name": "تونة ريو ماري بزيت الزيتون 160جم", "cost": 85.0, "retail": 110.0, "has_carton": True},
            {"name": "تونة دولفين مفتتة حارة 140جم", "cost": 30.0, "retail": 38.0, "has_carton": True},
        ],

        # --- 2203: Tomato Paste (صلصة طماطم) ---
        2203: [
            {"name": "صلصة هاينز برطمان 360جم", "cost": 25.0, "retail": 32.0, "has_carton": True},
            {"name": "صلصة فاين فودز 320جم", "cost": 22.0, "retail": 28.0, "has_carton": True},
            {"name": "صلصة هارفست ظرف 50جم", "cost": 4.0, "retail": 5.5, "has_carton": True},
            {"name": "صلصة روز جاردن صفيح 400جم", "cost": 20.0, "retail": 26.0, "has_carton": True},
        ],

        # --- 2302: Coffee & Nescafe (قهوة ونسكافيه) ---
        2302: [
            {"name": "نسكافيه كلاسيك برطمان 200جم", "cost": 180.0, "retail": 220.0, "has_carton": True},
            {"name": "بن عبد المعبود محوج 100جم", "cost": 45.0, "retail": 55.0, "has_carton": True},
            {"name": "بن أبو عوف سادة فاتح 250جم", "cost": 110.0, "retail": 135.0, "has_carton": True},
            {"name": "قهوة علي كافيه 3 في 1 (20 ظرف)", "cost": 75.0, "retail": 95.0, "has_carton": True},
        ],

        # --- 2304: Sodas & Water (مياه ومياه غازية) ---
        2304: [
            {"name": "بيبسي كانز 330 مل", "cost": 8.0, "retail": 10.0, "has_carton": True},
            {"name": "كوكاكولا زجاجة 1.5 لتر", "cost": 18.0, "retail": 23.0, "has_carton": True},
            {"name": "مياه صافي 1.5 لتر", "cost": 5.0, "retail": 7.0, "has_carton": True},
            {"name": "مياه داساني 600 مل", "cost": 3.0, "retail": 4.5, "has_carton": True},
            {"name": "سبرايت زجاجة 1 لتر", "cost": 14.0, "retail": 18.0, "has_carton": True},
        ],

        # --- 3103: Pane & Nuggets (بانيه وناجتس مجمد) ---
        3103: [
            {"name": "بانيه كوكي حار 1 كجم", "cost": 160.0, "retail": 195.0, "has_carton": True},
            {"name": "ناجتس أطياب 400جم", "cost": 85.0, "retail": 110.0, "has_carton": True},
            {"name": "ستربس دجاج حلواني 400جم", "cost": 95.0, "retail": 120.0, "has_carton": True},
            {"name": "بانيه المراعي عادي 750جم", "cost": 130.0, "retail": 160.0, "has_carton": True},
        ],

        # --- 4001: Washing Powders (مساحيق غسيل) ---
        4001: [
            {"name": "مسحوق اريال اتوماتيك 3 كجم", "cost": 210.0, "retail": 245.0, "has_carton": True},
            {"name": "مسحوق برسيل برائحة اللافندر 5 كجم", "cost": 320.0, "retail": 380.0, "has_carton": True},
            {"name": "مسحوق اوكسي للغسالات العادية 2.5 كجم", "cost": 110.0, "retail": 135.0, "has_carton": True},
            {"name": "تايد جل أوتوماتيك 2.8 لتر", "cost": 175.0, "retail": 205.0, "has_carton": True},
        ],

        # --- 4002: Dish Soaps (منظفات أطباق) ---
        4002: [
            {"name": "سائل أطباق فيري ليمون 450 مل", "cost": 35.0, "retail": 45.0, "has_carton": True},
            {"name": "سائل أطباق بريل تفاح 600 مل", "cost": 28.0, "retail": 35.0, "has_carton": True},
            {"name": "سائل أطباق اوكسي 1 لتر", "cost": 40.0, "retail": 50.0, "has_carton": True},
            {"name": "سائل أطباق لودفيك 750 مل", "cost": 45.0, "retail": 58.0, "has_carton": True},
        ],

        # --- 4101: Shampoo (شامبو) ---
        4101: [
            {"name": "شامبو بانتين انسيابي وحرير 400 مل", "cost": 65.0, "retail": 85.0, "has_carton": True},
            {"name": "شامبو هيد اند شولدرز نعناع 600 مل", "cost": 95.0, "retail": 125.0, "has_carton": True},
            {"name": "شامبو كلير للرجال 400 مل", "cost": 60.0, "retail": 78.0, "has_carton": True},
            {"name": "بلسم تريزيمي 500 مل", "cost": 85.0, "retail": 110.0, "has_carton": True},
        ],

        # --- 4201: Facial Tissues (مناديل وجه) ---
        4201: [
            {"name": "مناديل وايت 550 منديل (3 قطع)", "cost": 60.0, "retail": 75.0, "has_carton": True},
            {"name": "مناديل زينة 500 منديل", "cost": 22.0, "retail": 28.0, "has_carton": True},
            {"name": "مناديل فاميلي 250 منديل", "cost": 12.0, "retail": 16.0, "has_carton": True},
            {"name": "مناديل بابيا 3 طبقات (4 قطع)", "cost": 85.0, "retail": 105.0, "has_carton": True},
        ]
    }

def generate_products_data() -> List[Dict[str, Any]]:
    """
    Iterates through the base items and generates complete product dimension rows.
    Creates single unit and bulk (carton) variations dynamically.
    """
    products_data: List[Dict[str, Any]] = []
    item_counter = STARTING_ITEM_CODE
    
    dept_mapping = get_base_items_mapping()
    
    for dept_id, items in dept_mapping.items():
        for item in items:
            supplier_id = random.randint(1, 40)
            
            # Extract basic info mapping from department
            item_class = 1 if dept_id < 4000 else 2
            section = int(str(dept_id)[0]) if dept_id >= 1000 else 1
            item_group = int(str(dept_id)[:2]) if dept_id >= 1000 else 10
            
            # --- 1. Generate Single Piece ---
            products_data.append({
                "itemclass": item_class, 
                "section": section, 
                "itemgroup": item_group, 
                "department": dept_id,
                "a_name": item['name'], # Name already includes size/weight
                "retailprice": item['retail'], 
                "costprice": item['cost'], 
                "peices": 1, 
                "status": 1, 
                "itemean": f"{item_counter:08}", 
                "barcode": f"622300{item_counter:04}00", 
                "producerno": supplier_id
            })
            
            # --- 2. Generate Carton/Bulk ---
            if item["has_carton"]:
                carton_qty = random.choice([6, 12, 24]) 
                carton_retail = round((item['retail'] * carton_qty) * 0.95, 2)
                carton_cost = round(item['cost'] * carton_qty, 2)
                
                products_data.append({
                    "itemclass": item_class, 
                    "section": section, 
                    "itemgroup": item_group, 
                    "department": dept_id,
                    "a_name": f"{item['name']} - كرتونة {carton_qty}", 
                    "retailprice": carton_retail, 
                    "costprice": carton_cost, 
                    "peices": carton_qty, 
                    "status": 1, 
                    "itemean": f"{item_counter:08}", 
                    "barcode": f"622300{item_counter:04}{carton_qty:02}", 
                    "producerno": supplier_id
                })
                
            item_counter += 1
            
    return products_data

def save_to_csv(data: List[Dict[str, Any]], output_dir: str, file_name: str) -> None:
    os.makedirs(output_dir, exist_ok=True)
    file_path = os.path.join(output_dir, file_name)
    
    df = pd.DataFrame(data)
    df.to_csv(file_path, index=False, encoding='utf-8-sig')
    
    print(f" Success! Generated {len(df)} highly diversified product records.")
    print(f"File saved to: {file_path}")

if __name__ == "__main__":
    print("Starting diversified product dimension generation...")
    data = generate_products_data()
    save_to_csv(data, OUTPUT_DIR, FILE_NAME)