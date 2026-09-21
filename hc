<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>ค้นหาสเปคแผ่นพื้น Hollow Core</title>
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary-blue: #0056b3; --light-blue: #e8f4fd;
            --bg-color: #f0f2f5; --text-main: #333333;
            --text-muted: #666666; --border-color: #d1d5db;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-color); color: var(--text-main);
            display: flex; justify-content: center; align-items: flex-start;
            min-height: 100vh; padding: 20px 15px;
        }
        .container {
            background-color: #ffffff; width: 100%; max-width: 480px;
            padding: 30px 20px; border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }
        h2 { text-align: center; color: var(--primary-blue); font-size: 1.5rem; margin-bottom: 25px; font-weight: 700; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.95rem; color: var(--text-main); }
        select, input {
            width: 100%; height: 50px; padding: 0 15px;
            border: 1px solid var(--border-color); border-radius: 8px;
            font-size: 16px; background-color: #fafafa; color: var(--text-main);
            transition: all 0.3s;
        }
        select:focus, input:focus {
            outline: none; border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15); background-color: #fff;
        }
        button {
            width: 100%; height: 54px; background-color: var(--primary-blue);
            color: white; border: none; border-radius: 8px; font-size: 1.1rem;
            font-weight: bold; cursor: pointer; margin-top: 10px;
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.2); transition: background 0.3s, transform 0.1s;
        }
        button:active { transform: scale(0.98); }
        button:disabled { background-color: #9ca3af; cursor: not-allowed; box-shadow: none; }
        
        .result-box {
            margin-top: 25px; padding: 20px; border-radius: 12px;
            background-color: var(--light-blue); border: 1px solid #bce0fd;
            display: none; animation: fadeIn 0.4s ease;
        }
        .result-title { font-size: 0.9rem; color: var(--text-muted); margin-bottom: 5px; font-weight: bold;}
        .product-code { font-size: 0.9rem; color: var(--text-muted); font-weight: 600; letter-spacing: 0.5px; }
        .product-name { font-size: 1.8rem; font-weight: 800; color: var(--primary-blue); margin-bottom: 15px; letter-spacing: 0.5px; }
        .spec-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px dashed #bce0fd;
        }
        .spec-item:last-child { border-bottom: none; }
        .spec-label { font-weight: 600; color: var(--text-main); }
        .spec-value { font-weight: 700; color: #d97706; font-size: 1.1rem; }

        .error-box {
            margin-top: 25px; padding: 15px; border-radius: 8px;
            background-color: #fef2f2; border: 1px solid #fecaca;
            color: #dc2626; text-align: center; font-weight: 500;
            display: none; animation: fadeIn 0.4s ease;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<div class="container">
    <h2>ค้นหาสเปค Hollow Core</h2>
    
    <div class="form-group">
        <label>ความหนา (มม.)</label>
        <select id="thickness" onchange="updateWidthOptions()">
            <option value="">กำลังโหลดข้อมูล...</option>
        </select>
    </div>

    <div class="form-group">
        <label>ความกว้าง (มม.)</label>
        <!-- ⭐ เพิ่ม onchange เพื่อบอกว่า ถ้าความกว้างเปลี่ยน ให้ไปอัปเดตประเภทการเทด้วย -->
        <select id="width" onchange="updateToppingOptions()">
            <option value="">รอเลือกความหนา...</option>
        </select>
    </div>

    <div class="form-group">
        <label>ประเภทการเทคอนกรีต</label>
        <select id="toppingType">
            <option value="">รอเลือกความกว้าง...</option>
        </select>
    </div>

    <div class="form-group">
        <label>ระยะพาด / ความยาว (เมตร)</label>
        <input type="number" id="span" step="0.01" placeholder="ระบุระยะพาด เช่น 4.5" inputmode="decimal" required>
    </div>

    <div class="form-group">
        <label>Live Load (กก./ตร.ม.)</label>
        <input type="number" id="liveload" placeholder="ระบุน้ำหนักบรรทุก เช่น 250" inputmode="numeric" required>
    </div>

    <button onclick="searchProduct()" id="searchBtn" disabled>กำลังเตรียมระบบ...</button>

    <div class="result-box" id="resultBox">
        <div class="result-title">รุ่นที่เหมาะสมและประหยัดที่สุด:</div>
        <div class="product-code" id="resProductCode">CODE: -</div>
        <div class="product-name" id="resProductName">-</div>
        
        <div class="spec-item">
            <span class="spec-label">จำนวนลวด (น้อยที่สุด):</span>
            <span class="spec-value" id="resWireSpec">-</span>
        </div>
        <div class="spec-item">
            <span class="spec-label">การเทคอนกรีต:</span>
            <span class="spec-value" id="resTopping" style="color: var(--primary-blue);">-</span>
        </div>
        <div class="spec-item">
            <span class="spec-label">รองรับระยะพาดสูงสุด:</span>
            <span class="spec-value"><span id="resMaxSpan"></span> ม.</span>
        </div>
        <div class="spec-item">
            <span class="spec-label">รับน้ำหนักได้สูงสุด:</span>
            <span class="spec-value"><span id="resLiveLoad"></span> kg/m²</span>
        </div>
    </div>

    <div class="error-box" id="errorBox">
        ไม่พบสินค้าที่รองรับสเปคนี้<br>โปรดปรับความหนา, ลดระยะพาด หรือเปลี่ยนประเภทการเท
    </div>
</div>

<script>
    const SUPABASE_URL = 'https://iqzurohkdxcmyydixdmv.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxenVyb2hrZHhjbXl5ZGl4ZG12Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkwNjU1NDgsImV4cCI6MjA5NDY0MTU0OH0.Ks85DSc17zkPJ5Pzn-Ay7jO9vzsI2HkVXmlpUq8vewo';
    
    const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY, {
        db: { schema: 'HC' }
    });

    let allProductsData = [];

    // ดึงข้อมูลทั้งหมด 1 ครั้งตอนเปิดเว็บ
    async function loadDropdownData() {
        try {
            const { data, error } = await supabaseClient
                .from('products')
                .select('thickness, width, topping_type')
                .limit(10000);

            if (error) throw error;
            allProductsData = data; 

            // ใส่ข้อมูลความหนา (ชั้นที่ 1)
            const uniqueThickness = [...new Set(data.map(item => item.thickness))].sort((a, b) => a - b);
            const thicknessSelect = document.getElementById('thickness');
            thicknessSelect.innerHTML = '';
            uniqueThickness.forEach(t => {
                thicknessSelect.innerHTML += `<option value="${t}">${t} mm</option>`;
            });

            // สั่งให้อัปเดตความกว้างและการเทคอนกรีตทันทีที่โหลดเสร็จ
            updateWidthOptions();

            const btn = document.getElementById('searchBtn');
            btn.innerText = "คำนวณและค้นหาสินค้า";
            btn.disabled = false;

        } catch (error) {
            console.error("Error loading dropdowns:", error);
            alert("ไม่สามารถดึงข้อมูลตัวเลือกได้ โปรดตรวจสอบการเชื่อมต่อ");
        }
    }

    // ฟังก์ชันอัปเดตความกว้าง (ชั้นที่ 2)
    function updateWidthOptions() {
        const selectedThickness = document.getElementById('thickness').value;
        const widthSelect = document.getElementById('width');
        
        // หากรองตามความหนาที่เลือก
        const filteredData = allProductsData.filter(item => item.thickness == selectedThickness);
        const uniqueWidth = [...new Set(filteredData.map(item => item.width))].sort((a, b) => a - b);

        widthSelect.innerHTML = '';
        uniqueWidth.forEach(w => {
            widthSelect.innerHTML += `<option value="${w}">${w} mm</option>`;
        });

        // ⭐ สำคัญ: เมื่อความกว้างอัปเดตเสร็จ ต้องสั่งให้อัปเดตประเภทการเทคอนกรีตต่อทันที!
        updateToppingOptions();
    }

    // 🌟 ฟังก์ชันใหม่: กรองประเภทการเทคอนกรีต (ชั้นที่ 3)
    function updateToppingOptions() {
        const selectedThickness = document.getElementById('thickness').value;
        const selectedWidth = document.getElementById('width').value;
        const toppingSelect = document.getElementById('toppingType');

        // หากรองข้อมูลโดยใช้ทั้ง "ความหนา" และ "ความกว้าง" ประกอบกัน
        const filteredData = allProductsData.filter(item => 
            item.thickness == selectedThickness && item.width == selectedWidth
        );

        // ตัดตัวซ้ำ และกรองค่าว่างออก
        const uniqueTopping = [...new Set(filteredData.map(item => item.topping_type))].filter(item => item).sort();

        // ใส่ข้อมูลลงใน Dropdown
        toppingSelect.innerHTML = '<option value="">-- ไม่ระบุ (ค้นหาทั้งหมด) --</option>';
        uniqueTopping.forEach(top => {
            toppingSelect.innerHTML += `<option value="${top}">${top}</option>`;
        });
    }

    window.onload = loadDropdownData;

    // ฟังก์ชันค้นหาสินค้า
    async function searchProduct() {
        const thickness = parseInt(document.getElementById('thickness').value);
        const width = parseInt(document.getElementById('width').value);
        const toppingType = document.getElementById('toppingType').value;
        const span = parseFloat(document.getElementById('span').value);
        const liveload = parseInt(document.getElementById('liveload').value);

        if(!span || !liveload) {
            alert("กรุณากรอกระยะพาดและ Live Load ให้ครบถ้วน");
            return;
        }

        const btn = document.getElementById('searchBtn');
        btn.innerText = "กำลังค้นหา...";
        btn.disabled = true;

        document.getElementById('resultBox').style.display = 'none';
        document.getElementById('errorBox').style.display = 'none';

        try {
            let query = supabaseClient
                .from('products')
                .select('*')
                .eq('thickness', thickness)
                .eq('width', width)
                .gte('max_span', span)
                .gte('live_load', liveload);

            if (toppingType !== "") {
                query = query.eq('topping_type', toppingType);
            }

            query = query
                .order('topping_type', { ascending: false })
                .order('wire_rank', { ascending: true }) 
                .order('max_span', { ascending: true })
                .order('live_load', { ascending: true })
                .limit(1);

            const { data, error } = await query;

            if (error) throw error;
            
            if (data && data.length > 0) {
                const product = data[0];
                document.getElementById('resProductCode').innerText = "CODE: " + (product.product_code || '-');
                document.getElementById('resProductName').innerText = product.product_name;
                document.getElementById('resWireSpec').innerText = product.wire_spec;
                document.getElementById('resTopping').innerText = product.topping_type || '-';
                document.getElementById('resMaxSpan').innerText = product.max_span;
                document.getElementById('resLiveLoad').innerText = product.live_load;
                
                document.getElementById('resultBox').style.display = 'block';
            } else {
                document.getElementById('errorBox').style.display = 'block';
            }

        } catch (error) {
            console.error('Error:', error);
            alert("เกิดข้อผิดพลาดในการเชื่อมต่อเครือข่าย โปรดลองอีกครั้ง");
        } finally {
            btn.innerText = "คำนวณและค้นหาสินค้า";
            btn.disabled = false;
        }
    }
</script>

</body>
</html>