"""
Module: generate_suppliers.py
Description: Generates a comprehensive synthetic dimension table for suppliers 
             (Dim_Suppliers). Covers major FMCG companies, fresh food farms, 
             and service providers in Egypt. Uses English-transliterated 
             Egyptian names and cities for better database compatibility.
"""

import pandas as pd
import os
import random
from datetime import datetime, timedelta
from typing import List, Dict, Any

# --- Configuration Constants ---
OUTPUT_DIR = "./data_source/"
FILE_NAME = "dim_suppliers.csv"

# --- Synthetic Data Lists (English Transliterated) ---
FIRST_NAMES = [
    "Ahmed", "Mohamed", "Mahmoud", "Mostafa", "Omar", "Ali", "Karim", 
    "Tarek", "Youssef", "Khaled", "Amr", "Mina", "Hassan", "Hussein",
    "Sarah", "Aya", "Nour", "Mai", "Dina", "Salma", "Fatma", "Noha"
]

LAST_NAMES = [
    "Ali", "Ibrahim", "Hassan", "Soliman", "Gaber", "Fathy", "Said", 
    "Tawfik", "Osman", "Mansour", "El-Sayed", "Radwan", "Kamel", "Farouk"
]

CITIES = [
    "Cairo", "Giza", "Alexandria", "Al-Zagazig", "10th of Ramadan", 
    "Tanta", "Mansoura", "Suez", "Port Said", "Ismailia", "Minya", "Assiut"
]

def get_suppliers_info() -> List[Dict[str, str]]:
    """
    Returns a comprehensive list of real-world suppliers covering all 
    hypermarket departments, mapped to their actual English email domains.
    """
    return [
        # --- FMCG & Grocery ---
        {"name": "جهينة للصناعات الغذائية", "domain": "juhayna.com"},
        {"name": "بيتي (المراعي)", "domain": "beyti.com"},
        {"name": "دومتي", "domain": "domty.com"},
        {"name": "لمار مصر", "domain": "lamar.com"},
        {"name": "نستله مصر", "domain": "nestle.com.eg"},
        {"name": "بيبسيكو (شيبسي - بيبسي)", "domain": "pepsico.com.eg"},
        {"name": "كوكاكولا مصر", "domain": "cocacola.com.eg"},
        {"name": "إيديتا للصناعات الغذائية", "domain": "edita.com.eg"},
        {"name": "يونيليفر مشرق (أومو - ليبتون)", "domain": "unilever.com.eg"},
        {"name": "بروكتر آند جامبل (إيريال - بانتين)", "domain": "pg.com"},
        {"name": "أرما للصناعات الغذائية", "domain": "arma.com.eg"},
        {"name": "صافولا مصر (عافية - روابي)", "domain": "savola.com"},
        {"name": "حلواني إخوان", "domain": "halwani.com.eg"},
        {"name": "الرشيدي الميزان", "domain": "elrashidi.com"},
        {"name": "مجموعة فرج الله", "domain": "faragalla.com"},
        {"name": "دريم", "domain": "dreem.com.eg"},
        {"name": "أبو عوف", "domain": "abuauf.com"},
        {"name": "بسكو مصر (كيلوجز)", "domain": "biscomisr.com"},
        {"name": "كورونا", "domain": "corona.com.eg"},
        {"name": "مونديليز مصر (كادبوري - أوريو)", "domain": "mondelez.com"},
        {"name": "هيرو للصناعات الغذائية (فيتراك)", "domain": "hero-group.ch"},
        {"name": "أمريكانا للأغذية", "domain": "americana-group.com"},
        {"name": "مخابز ريتش بيك", "domain": "richbake.com"},
        {"name": "هاينز مصر", "domain": "kraftheinz.com"},
        {"name": "الضحي للمواد الغذائية", "domain": "eldoha.com"},
        {"name": "السوهاجي", "domain": "elsohagy.com"},
        {"name": "عاصم للعطارة", "domain": "assem-spices.com"},
        {"name": "قها للأغذية المحفوظة", "domain": "kaha.com.eg"},
        {"name": "إدفينا", "domain": "edfina.com.eg"},
        
        # --- Fresh Food (Meat, Fish, Farms, Vegetables) ---
        {"name": "أطياب للحوم المصنعة", "domain": "atyab.com"},
        {"name": "دواجن كوكي", "domain": "koki.com"},
        {"name": "الشركة الوطنية للدواجن", "domain": "watania.com"},
        {"name": "مزارع دينا", "domain": "dinafarms.com"},
        {"name": "أسماك النيل", "domain": "nilefish.com"},
        {"name": "الشركة المصرية لتسويق الأسماك", "domain": "egyfish.com.eg"},
        {"name": "مزارع الفيروز للخضروات", "domain": "alfayrouz.com"},
        {"name": "الشركة المتحدة للحوم", "domain": "unitedmeats.com"},
        {"name": "شركة الأهرام للدواجن", "domain": "ahrampoultry.com"},
        
        # --- Non-Food (Detergents, Paper Products, Housewares) ---
        {"name": "شركة فاين الصحية", "domain": "finehh.com"},
        {"name": "ورقيات زينة", "domain": "zeina.com"},
        {"name": "ريكيت بنكيزر (ديتول)", "domain": "reckitt.com"},
        {"name": "لوريال مصر", "domain": "loreal.com.eg"},
        {"name": "جونسون آند جونسون", "domain": "jnj.com"},
        {"name": "شركة النيل للزيوت والمنظفات", "domain": "nileoils.com"},
        {"name": "إيفا كوزمتكس", "domain": "eva-cosmetics.com"},
        {"name": "تنمية الصناعات الكيماوية (سيد)", "domain": "cid.com.eg"},
        {"name": "الهلال والنجمة الفضية (أدوات منزلية)", "domain": "helal.com.eg"},
        {"name": "نوفال للأدوات المنزلية", "domain": "nouval.com"},
        
        # --- Services (Delivery, Vouchers, Packaging) ---
        {"name": "فوري لخدمات الدفع الإلكتروني", "domain": "fawry.com"},
        {"name": "أمان للخدمات المالية", "domain": "aman.eg"},
        {"name": "شركة طلبات للتوصيل", "domain": "talabat.com"},
        {"name": "الشركة المصرية للتغليف والورق", "domain": "egywrap.com"},
        {"name": "ماي فوري", "domain": "myfawry.com"},
        {"name": "فودافون كاش (خدمات الدفع)", "domain": "vodafone.com.eg"}
    ]

def generate_suppliers_data() -> List[Dict[str, Any]]:
    """
    Iterates over supplier names to generate complete business profiles 
    including tax IDs, payment terms, and contact details.
    """
    suppliers_info = get_suppliers_info()
    suppliers_data: List[Dict[str, Any]] = []
    
    for i, info in enumerate(suppliers_info, start=1):
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
        
        # Use the mapped English domain for the email
        email = f"info@{info['domain']}"
        
        # Generate English-written Egyptian name and city
        contact_name = f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}"
        city_name = random.choice(CITIES)
        
        suppliers_data.append({
            "supplier_id": i,
            "supplier_name": info['name'],
            "contact_person": contact_name,
            "phone_number": phone,
            "email": email,
            "city": city_name,
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
    
    print(f" Success! Generated {len(df_suppliers)} supplier records with English names and cities.")
    print(f" File saved to: {file_path}")

if __name__ == "__main__":
    print("Starting suppliers dimension generation...")
    data = generate_suppliers_data()
    save_to_csv(data, OUTPUT_DIR, FILE_NAME)