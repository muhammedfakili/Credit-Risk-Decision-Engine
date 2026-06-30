DO $$
DECLARE
    col record;
BEGIN
    -- 1. application_train tablosu için
    FOR col IN SELECT column_name FROM information_schema.columns WHERE table_name = 'application_train' LOOP
        EXECUTE format('ALTER TABLE application_train RENAME COLUMN %I TO %I', col.column_name, lower(col.column_name));
    END LOOP;
    
    -- 2. bureau tablosu için
    FOR col IN SELECT column_name FROM information_schema.columns WHERE table_name = 'bureau' LOOP
        EXECUTE format('ALTER TABLE bureau RENAME COLUMN %I TO %I', col.column_name, lower(col.column_name));
    END LOOP;

    -- 3. installments_payments tablosu için
    FOR col IN SELECT column_name FROM information_schema.columns WHERE table_name = 'installments_payments' LOOP
        EXECUTE format('ALTER TABLE installments_payments RENAME COLUMN %I TO %I', col.column_name, lower(col.column_name));
    END LOOP;
END;
$$;


SELECT 
    target, 
    COUNT(sk_id_curr) as musteri_sayisi,
    ROUND(COUNT(sk_id_curr) * 100.0 / (SELECT COUNT(*) FROM application_train), 2) as yuzdelik_oran
FROM 
    application_train
GROUP BY 
    target;


SELECT 
    sk_id_curr,               -- Müşterinin kimliğini getir
    amt_credit,               -- Çektiği kredi miktarını getir
    days_birth / -365 AS yas  -- Günleri yıla çevir, eksiden kurtar ve sütun adını 'yas' yap
FROM 
    application_train         -- Hangi tablodan veri çekiyoruz?
WHERE 
    (days_birth / -365) < 30  -- Filtre: Sadece hesaplanan yaşı 30'dan küçük olanları al
ORDER BY 
    amt_credit DESC           -- Çekilen krediye (amt_credit) göre azalan (DESCending) şekilde sırala
LIMIT 5;                      -- Sadece en yüksek ilk 5 satırı göster



SELECT 
    app.sk_id_curr, 
    (app.days_birth / -365) AS yas,
    app.amt_credit AS bizden_istenen_kredi,
    COUNT(b.sk_id_bureau) AS baska_bankalardaki_kredi_sayisi,
    SUM(b.amt_credit_sum) AS baska_bankalardaki_toplam_borc
FROM 
    application_train app             -- 'app' takma adını (alias) verdik ki uzun uzun yazmayalım
LEFT JOIN 
    bureau b ON app.sk_id_curr = b.sk_id_curr  -- 'b' takma adlı tabloyu ID'ler üzerinden birleştir
WHERE 
    (app.days_birth / -365) < 30      -- Sadece 30 yaş altını filtrele
GROUP BY 
    app.sk_id_curr, app.days_birth, app.amt_credit  -- Aggregation (COUNT, SUM) kullandığımız için diğerlerini grupladık
ORDER BY 
    app.amt_credit DESC               -- Bizden istenen krediye göre sırala
LIMIT 5;




WITH TemizMusteri AS (
    -- 1. ADIM: SANAL TABLO OLUŞTURMA
    SELECT 
        sk_id_curr,
        amt_income_total AS yillik_gelir,
        amt_credit AS istenen_kredi,
        (days_birth / -365) AS yas
    FROM 
        application_train
    WHERE 
        (days_birth / -365) < 30
)
-- 2. ADIM: ANA SORGU
SELECT 
    tm.sk_id_curr,
    tm.yas,
    tm.yillik_gelir,
    tm.istenen_kredi,
    COALESCE(SUM(b.amt_credit_sum), 0) AS diger_banka_borcu,
    -- İŞTE BURAYI DEĞİŞTİRDİK: Bölme işlemini paranteze alıp sonuna ::numeric ekledik
    ROUND((COALESCE(SUM(b.amt_credit_sum), 0) / tm.yillik_gelir)::numeric, 2) AS borc_gelir_orani
FROM 
    TemizMusteri tm
LEFT JOIN 
    bureau b ON tm.sk_id_curr = b.sk_id_curr
GROUP BY 
    tm.sk_id_curr, tm.yas, tm.yillik_gelir, tm.istenen_kredi
ORDER BY 
    tm.istenen_kredi DESC
LIMIT 5;




SELECT 
    sk_id_curr,
    num_instalment_number AS taksit_sirasi,
    amt_instalment AS beklenen_tutar,
    amt_payment AS odenen_tutar,
    
    -- 1. PENCERE FONKSİYONU: Bir önceki ayın ödemesini yanına getir
    LAG(amt_payment, 1) OVER (PARTITION BY sk_id_curr ORDER BY num_instalment_number) AS onceki_ay_odenen,
    
    -- 2. PENCERE FONKSİYONU: Ödemeleri kümülatif olarak toplayarak git
    SUM(amt_payment) OVER (PARTITION BY sk_id_curr ORDER BY num_instalment_number) AS kumulatif_toplam
FROM 
    installments_payments
WHERE 
    sk_id_curr = (SELECT sk_id_curr FROM installments_payments LIMIT 1) -- Tablodaki ilk dolu müşteriyi otomatik seç
ORDER BY 
    num_instalment_number
LIMIT 10;





SELECT 
    sk_id_curr,
    sk_id_prev, -- Hangi kredi olduğunu görmek için bunu ekledik
    num_instalment_number AS taksit_sirasi,
    amt_instalment AS beklenen_tutar,
    amt_payment AS odenen_tutar,
    
    -- PENCERE 1: Kredi ID'sine ve Müşteriye göre böl, taksite göre sırala
    LAG(amt_payment, 1) OVER (PARTITION BY sk_id_curr, sk_id_prev ORDER BY num_instalment_number) AS onceki_ay_odenen,
    
    -- PENCERE 2: Kümülatif toplamı hesaplarken kredileri birbirine karıştırma
    SUM(amt_payment) OVER (PARTITION BY sk_id_curr, sk_id_prev ORDER BY num_instalment_number) AS kumulatif_toplam
FROM 
    installments_payments
WHERE 
    sk_id_curr = 161674 -- Senin ekranda bulduğumuz o Müşteri ID'sini kullandık
ORDER BY 
    sk_id_prev, num_instalment_number -- Önce krediyi, sonra taksitleri sırala
LIMIT 15;
































