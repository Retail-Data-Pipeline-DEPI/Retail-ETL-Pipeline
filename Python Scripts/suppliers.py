"""
Module: generate_suppliers.py
Description: Generates a comprehensive synthetic dimension table for suppliers 
             (Dim_Suppliers). Covers major FMCG companies, fresh food farms, 
             and service providers in Egypt. Incorporates Faker for realistic 
             contact info and follows Data Engineering best practices.
"""

import pandas as pd
import os
import random
from datetime import datetime, timedelta
from typing import List, Dict, Any
from faker import Faker

# --- Configuration Constants ---
OUTPUT_DIR = "./data_source/"
FILE_NAME = "dim_suppliers.csv"

def get_supplier_names() -> List[str]:
    """
    Returns a comprehensive list of real-world suppliers covering all 
    hypermarket departments (Food, Non-Food, Fresh, and Services).
    """
    return [
        # --- FMCG & Grocery ---
        "جهينة للصناعات الغذائية", "بيتي (المراعي)", "دومتي", "لمار مصر",
        "نستله مصر", "بيبسيكو (شيبسي - بيبسي)", "كوكاكولا مصر", "إيديتا للصناعات الغذائية",
        "يونيليفر مشرق (أومو - ليبتون)", "بروكتر آند جامبل (إيريال - بانتين)", "أرما للصناعات الغذائية",
        "صافولا مصر (عافية - روابي)", "حلواني إخوان", "الرشيدي الميزان", "مجموعة فرج الله",
        "دريم", "أبو عوف", "بسكو مصر (كيلوجز)", "كورونا", "مونديليز مصر (كادبوري - أوريو)",
        "هيرو للصناعات الغذائية (فيتراك)", "أمريكانا للأغذية", "مخابز ريتش بيك", "هاينز مصر",
        "الضحي للمواد الغذائية", "السوهاجي", "عاصم للعطارة", "قها للأغذية المحفوظة", "إدفينا",
        
        # --- Fresh Food (Meat, Fish, Farms, Vegetables) ---
        "أطياب للحوم المصنعة", "دواجن كوكي", "الشركة الوطنية للدواجن", "مزارع دينا",
        "أسماك النيل", "الشركة المصرية لتسويق الأسماك", "مزارع الفيروز للخضروات",
        "الشركة المتحدة للحوم", "شركة الأهرام للدواجن",
        
        # --- Non-Food (Detergents, Paper Products, Housewares) ---
        "شركة فاين الصحية", "ورقيات زينة", "ريكيت بنكيزر (ديتول)", "لوريال مصر", 
        "جونسون آند جونسون", "شركة النيل للزيوت والمنظفات", "إيفا كوزمتكس",
        "تنمية الصناعات الكيماوية (سيد)", "الهلال والنجمة الفضية (أدوات منزلية)", "نوفال للأدوات المنزلية",
        
        # --- Services (Delivery, Vouchers, Packaging) ---
        "فوري لخدمات الدفع الإلكتروني", "أمان للخدمات المالية", "شركة طلبات للتوصيل",
        "الشركة المصرية للتغليف والورق", "ماي فوري", "فودافون كاش (خدمات الدفع)"
    ]

def generate_suppliers_data() -> List[Dict[str, Any]]:
    """
    Iterates over supplier names to generate complete business profiles 
    including tax IDs, payment terms, and contact details.
    
    Returns:
        List[Dict[str, Any]]: Generated supplier data ready for DataFrame conversion.
    """
    # Initialize Faker with ar_EG locale to generate realistic Arabic contact names and cities
    fake = Faker('ar_EG')
    supplier_names = get_supplier_names()
    suppliers_data: List[Dict[str, Any]] = []
    
    for i, name in enumerate(supplier_names, start=1):
        # Status distribution: 85% Active (1), 15% Inactive (0)
        is_active = 1 if random.random() > 0.15 else 0
        
        # Generate a random entry date from Jan 1st, 2017 to present
        random_days = random.randint(0, 2500)
        entry_date = (datetime(2017, 1, 1) + timedelta(days=random_days)).strftime("%Y-%m-%d")
        
        # Egyptian Tax Registration Number Format: XXX-XXX-XXX
        tax_id = f"{random.randint(100, 999)}-{random.randint(100, 999)}-{random.randint(100, 999)}"
        
        # Standard procurement payment terms
        payment_terms = random.choice(["Cash", "Net 30 Days", "Net 60 Days", "Net 90 Days"])
        
        # Realistic Egyptian mobile number generation (010, 011, 012, 015)
        prefix = random.choice(['010', '011', '012', '015'])
        phone = f"{prefix}{random.randint(1000000, 9999999)}"
        
        # Simplified corporate email generation based on the first word of the supplier's name
        email_prefix = name.split()[0].lower().replace('(', '').replace(')', '')
        
        suppliers_data.append({
            "supplier_id": i,
            "supplier_name": name,
            "contact_person": fake.name(),
            "phone_number": phone,
            "email": f"info@{email_prefix}_eg.com",
            "city": fake.city(),
            "tax_id": tax_id,
            "payment_terms": payment_terms,
            "status": is_active,
            "entry_date": entry_date
        })
        
    return suppliers_data

def save_to_csv(data: List[Dict[str, Any]], output_dir: str, file_name: str) -> None:
    """
    Exports the generated dictionary list to a CSV file.
    """
    # Ensure the target directory exists
    os.makedirs(output_dir, exist_ok=True)
    file_path = os.path.join(output_dir, file_name)
    
    # Create DataFrame and export with utf-8-sig to preserve Arabic characters
    df_suppliers = pd.DataFrame(data)
    df_suppliers.to_csv(file_path, index=False, encoding='utf-8-sig')
    
    print(f" Success! Generated {len(df_suppliers)} comprehensive supplier records.")
    print(f" File saved to: {file_path}")

if __name__ == "__main__":
    print("Starting suppliers dimension generation...")
    data = generate_suppliers_data()
    save_to_csv(data, OUTPUT_DIR, FILE_NAME)