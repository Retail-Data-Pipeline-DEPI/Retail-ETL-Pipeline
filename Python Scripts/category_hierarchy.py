"""
Module: category_hierarchy.py
Description: Generates a comprehensive synthetic dimension table for the product hierarchy 
             (Dim_Hierarchy) representing a large-scale hypermarket structure, 
             including Food, Non-Food, and Services.
             Follows best practices for Data Engineering and ETL pipelines.
"""

import pandas as pd
import os
from typing import List, Dict, Any

# --- Configuration Constants ---
OUTPUT_DIR = "./data_source/"
FILE_NAME = "dim_hierarchy.csv"

def generate_hierarchy_data() -> List[Dict[str, Any]]:
    """
    Constructs the product hierarchy data based on a standard ERP/Retail tree structure.
    
    Levels of Hierarchy:
    1. Item Class (e.g., Food, Non-Food, Services)
    2. Section (e.g., Fresh Food, Grocery, Frozen)
    3. Item Group (e.g., Meat, Dairy, Canned Food)
    4. Department / Specific Category (e.g., Minced Meat, Yogurt)
    
    Returns:
        List[Dict[str, Any]]: A list of dictionaries representing the hierarchy rows.
    """
    
    hierarchy_data: List[Dict[str, Any]] = [
        
        # ========================================================
        # CLASS 1: FOOD (مواد غذائية)
        # ========================================================
        
        # --- Section 1: Fresh Food (مواد غذائية طازجة) ---
        # Group 10: Meat & Poultry (لحوم ودواجن)
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 10, "group_name": "لحوم ودواجن", "department": 1001, "dept_name": "لحوم طازجة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 10, "group_name": "لحوم ودواجن", "department": 1002, "dept_name": "لحوم مفرومة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 10, "group_name": "لحوم ودواجن", "department": 1003, "dept_name": "دواجن كاملة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 10, "group_name": "لحوم ودواجن", "department": 1004, "dept_name": "قطع دواجن"},
        
        # Group 11: Seafood (أسماك ومأكولات بحرية)
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 11, "group_name": "أسماك ومأكولات بحرية", "department": 1101, "dept_name": "أسماك طازجة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 11, "group_name": "أسماك ومأكولات بحرية", "department": 1102, "dept_name": "قشريات ومحار"},
        
        # Group 12: Fruits & Vegetables (خضروات وفواكه)
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 12, "group_name": "خضروات وفواكه", "department": 1201, "dept_name": "خضروات ورقية"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 12, "group_name": "خضروات وفواكه", "department": 1202, "dept_name": "فواكه موسمية"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 12, "group_name": "خضروات وفواكه", "department": 1203, "dept_name": "خضروات جذرية"},
        
        # Group 13: Dairy & Cheese (ألبان وأجبان)
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 13, "group_name": "ألبان وأجبان", "department": 1301, "dept_name": "أجبان بيضاء ورومية"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 13, "group_name": "ألبان وأجبان", "department": 1302, "dept_name": "زبادي"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 13, "group_name": "ألبان وأجبان", "department": 1303, "dept_name": "حليب طازج ومبستر"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 13, "group_name": "ألبان وأجبان", "department": 1304, "dept_name": "زبدة وقشطة"},
        
        # Group 14: Bakery (مخبوزات وحلويات)
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 14, "group_name": "مخبوزات وحلويات", "department": 1401, "dept_name": "خبز عربي"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 14, "group_name": "مخبوزات وحلويات", "department": 1402, "dept_name": "خبز أفرنجي"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 14, "group_name": "مخبوزات وحلويات", "department": 1403, "dept_name": "حلويات غربية"},
        {"itemclass": 1, "class_name": "غذائي", "section": 1, "section_name": "مواد غذائية طازجة", "itemgroup": 14, "group_name": "مخبوزات وحلويات", "department": 1404, "dept_name": "كيك ومخبوزات مغلفة"},

        # --- Section 2: Grocery (بقالة جافة) ---
        # Group 20: Cereals & Legumes (حبوب وبقوليات)
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 20, "group_name": "حبوب وبقوليات", "department": 2001, "dept_name": "أرز"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 20, "group_name": "حبوب وبقوليات", "department": 2002, "dept_name": "مكرونة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 20, "group_name": "حبوب وبقوليات", "department": 2003, "dept_name": "عدس وبقوليات أخرى"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 20, "group_name": "حبوب وبقوليات", "department": 2004, "dept_name": "سكر"},
        
        # Group 21: Oils & Ghee (زيوت وسمن)
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 21, "group_name": "زيوت وسمن", "department": 2101, "dept_name": "زيت زيتون"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 21, "group_name": "زيوت وسمن", "department": 2102, "dept_name": "زيت ذرة وعباد"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 21, "group_name": "زيوت وسمن", "department": 2103, "dept_name": "سمن نباتي وحيواني"},
        
        # Group 22: Canned Food (معلبات)
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 22, "group_name": "معلبات", "department": 2201, "dept_name": "تونة وأسماك معلبة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 22, "group_name": "معلبات", "department": 2202, "dept_name": "فول وبقوليات معلبة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 22, "group_name": "معلبات", "department": 2203, "dept_name": "صلصة ومعجون طماطم"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 22, "group_name": "معلبات", "department": 2204, "dept_name": "خضار وفواكه معلبة"},
        
        # Group 23: Beverages (مشروبات)
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 23, "group_name": "مشروبات", "department": 2301, "dept_name": "شاي"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 23, "group_name": "مشروبات", "department": 2302, "dept_name": "قهوة ونسكافيه"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 23, "group_name": "مشروبات", "department": 2303, "dept_name": "عصائر ومشروبات طبيعية"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 23, "group_name": "مشروبات", "department": 2304, "dept_name": "مياه غازية ومعدنية"},
        
        # Group 24: Spices & Nuts (مكسرات وبهارات)
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 24, "group_name": "مكسرات وبهارات", "department": 2401, "dept_name": "توابل وبهارات"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 24, "group_name": "مكسرات وبهارات", "department": 2402, "dept_name": "مكسرات وتسالي"},
        {"itemclass": 1, "class_name": "غذائي", "section": 2, "section_name": "بقالة جافة", "itemgroup": 24, "group_name": "مكسرات وبهارات", "department": 2403, "dept_name": "عطارة وأعشاب"},

        # --- Section 3: Frozen Foods (مجمدات) ---
        # Group 30: Frozen Veggies (خضروات مجمدة)
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 30, "group_name": "خضروات مجمدة", "department": 3001, "dept_name": "بسلة مجمدة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 30, "group_name": "خضروات مجمدة", "department": 3002, "dept_name": "ملوخية مجمدة"},
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 30, "group_name": "خضروات مجمدة", "department": 3003, "dept_name": "خضار مشكل"},
        
        # Group 31: Frozen Meats (لحوم ومصنعات مجمدة)
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 31, "group_name": "لحوم ومصنعات مجمدة", "department": 3101, "dept_name": "برجر"},
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 31, "group_name": "لحوم ومصنعات مجمدة", "department": 3102, "dept_name": "سجق ومفروم"},
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 31, "group_name": "لحوم ومصنعات مجمدة", "department": 3103, "dept_name": "بانيه وناجتس"},
        
        # Group 32: Ice Cream & Sweets (آيس كريم وحلويات)
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 32, "group_name": "آيس كريم وحلويات مجمدة", "department": 3201, "dept_name": "آيس كريم"},
        {"itemclass": 1, "class_name": "غذائي", "section": 3, "section_name": "مجمدات", "itemgroup": 32, "group_name": "آيس كريم وحلويات مجمدة", "department": 3202, "dept_name": "عجائن جاهزة (بيتزا وسمبوسك)"},

        # ========================================================
        # CLASS 2: NON-FOOD (غير غذائي)
        # ========================================================
        
        # --- Section 4: Detergents & Personal Care (منظفات وعناية شخصية) ---
        # Group 40: Household Cleaners (منظفات منزلية)
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 40, "group_name": "منظفات منزلية", "department": 4001, "dept_name": "مساحيق غسيل أوتوماتيك وعادي"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 40, "group_name": "منظفات منزلية", "department": 4002, "dept_name": "منظفات أطباق"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 40, "group_name": "منظفات منزلية", "department": 4003, "dept_name": "منظفات أسطح وزجاج"},
        
        # Group 41: Personal Care (عناية شخصية)
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 41, "group_name": "عناية شخصية", "department": 4101, "dept_name": "شامبو وبلسم"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 41, "group_name": "عناية شخصية", "department": 4102, "dept_name": "صابون وشاور جل"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 41, "group_name": "عناية شخصية", "department": 4103, "dept_name": "معجون وفرش أسنان"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 41, "group_name": "عناية شخصية", "department": 4104, "dept_name": "كريمات وعناية بالبشرة"},
        
        # Group 42: Paper Products (منتجات ورقية)
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 42, "group_name": "منتجات ورقية", "department": 4201, "dept_name": "مناديل وجه"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 42, "group_name": "منتجات ورقية", "department": 4202, "dept_name": "ورق تواليت"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 4, "section_name": "منظفات وعناية شخصية", "itemgroup": 42, "group_name": "منتجات ورقية", "department": 4203, "dept_name": "فوط مطبخ"},

        # --- Section 5: Housewares & Electronics (أدوات منزلية وإلكترونيات) ---
        # Group 50: Kitchenware (أدوات مطبخ)
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 50, "group_name": "أدوات مطبخ", "department": 5001, "dept_name": "أواني وطاسات"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 50, "group_name": "أدوات مطبخ", "department": 5002, "dept_name": "أدوات مائدة وكاسات"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 50, "group_name": "أدوات مطبخ", "department": 5003, "dept_name": "بلاستيكيات وعلب حفظ"},
        
        # Group 51: Small Electronics (إلكترونيات صغيرة)
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 51, "group_name": "إلكترونيات صغيرة", "department": 5101, "dept_name": "خلاطات وكبات"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 51, "group_name": "إلكترونيات صغيرة", "department": 5102, "dept_name": "مكواة"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 51, "group_name": "إلكترونيات صغيرة", "department": 5103, "dept_name": "غلايات مياه"},
        
        # Group 52: Mobile Accessories (إكسسوارات جوال)
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 52, "group_name": "إكسسوارات جوال", "department": 5201, "dept_name": "شواحن وكابلات"},
        {"itemclass": 2, "class_name": "غير غذائي", "section": 5, "section_name": "أدوات منزلية وإلكترونيات", "itemgroup": 52, "group_name": "إكسسوارات جوال", "department": 5202, "dept_name": "سماعات"},

        # ========================================================
        # CLASS 3: SERVICES (خدمات)
        # ========================================================
        
        # --- Section 7: Customer Services (خدمات العملاء) ---
        # Group 110: Delivery (خدمات توصيل)
        {"itemclass": 3, "class_name": "خدمات", "section": 7, "section_name": "خدمات العملاء", "itemgroup": 110, "group_name": "خدمات توصيل", "department": 4001, "dept_name": "رسوم توصيل للمنازل"},
        
        # Group 111: Cards & Vouchers (كروت وبطاقات)
        {"itemclass": 3, "class_name": "خدمات", "section": 7, "section_name": "خدمات العملاء", "itemgroup": 111, "group_name": "كروت وبطاقات", "department": 4010, "dept_name": "كروت شحن موبايل"},
        {"itemclass": 3, "class_name": "خدمات", "section": 7, "section_name": "خدمات العملاء", "itemgroup": 111, "group_name": "كروت وبطاقات", "department": 4011, "dept_name": "قسائم شراء هدايا"},
        
        # Group 112: Packaging (تغليف وشنط)
        {"itemclass": 3, "class_name": "خدمات", "section": 7, "section_name": "خدمات العملاء", "itemgroup": 112, "group_name": "تغليف وشنط", "department": 4020, "dept_name": "شنط بلاستيك وورقية"},
        {"itemclass": 3, "class_name": "خدمات", "section": 7, "section_name": "خدمات العملاء", "itemgroup": 112, "group_name": "تغليف وشنط", "department": 4021, "dept_name": "خدمة تغليف هدايا"}
    ]
    
    return hierarchy_data

def save_to_csv(data: List[Dict[str, Any]], output_dir: str, file_name: str) -> None:
    """
    Converts the list of dictionaries to a Pandas DataFrame and saves it as a CSV.
    
    Args:
        data (List[Dict[str, Any]]): The hierarchy data.
        output_dir (str): The directory where the file will be saved.
        file_name (str): The name of the CSV file.
    """
    # Ensure the target directory exists
    os.makedirs(output_dir, exist_ok=True)
    
    # Define the full file path
    file_path = os.path.join(output_dir, file_name)
    
    # Create DataFrame and export to CSV
    # Using 'utf-8-sig' to ensure Arabic characters display correctly in Excel
    df_hierarchy = pd.DataFrame(data)
    df_hierarchy.to_csv(file_path, index=False, encoding='utf-8-sig')
    
    print(f" Success! Generated {len(df_hierarchy)} hierarchy records.")
    print(f" File saved to: {file_path}")

if __name__ == "__main__":
    # Execute the pipeline
    print("Starting category hierarchy generation...")
    data = generate_hierarchy_data()
    save_to_csv(data, OUTPUT_DIR, FILE_NAME)