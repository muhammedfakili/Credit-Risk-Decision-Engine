# 🚀 Uçtan Uca Kredi Risk Tahminleme ve Karar Destek Sistemi

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![XGBoost](https://img.shields.io/badge/XGBoost-1793D1?style=for-the-badge&logo=xgboost&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

## 📌 Proje Özeti
**367.9 Milyon Dolarlık** bir kredi portföyünde, geleneksel skorlama modelleri kritik batık (default) desenlerini yakalamakta yetersiz kalmış ve portföyü yaklaşık 27.9 Milyon Dolarlık bir risk altında bırakmıştır. Bu proje, "Kötü" (Bad) statüsündeki hesapları finansal bir kayba dönüşmeden önce tespit etmeyi amaçlayan, **Uçtan Uca bir Yapay Zeka ve İş Zekası (BI) Mimarisidir.**

Veritabanı (PostgreSQL), makine öğrenmesi (XGBoost) ve C-Level raporlama (Power BI) aşamalarını tek bir potada eriten bu karar destek sistemi; ham veriyi yöneticiler için aksiyona dönüştürülebilir finansal bir stratejiye çevirir.

## 🎯 Finansal Etki (Business Impact)
Riskli bankacılık operasyonlarında en kritik metrik **Duyarlılık'tır (Recall)**. Yüksek riskli bir müşteriyi gözden kaçırmanın maliyeti, güvenli bir müşteriyi yanlışlıkla reddetmekten çok daha ağırdır.
* **Recall (Duyarlılık) Başarısı:** %54 
* **Finansal Katma Değer:** Model, yüksek riskli başvuru sahiplerinin %54'ünü doğru bir şekilde tespit ederek, yaklaşık **13.0 Milyon Dolar** değerinde potansiyel kredi batığını engelleme kapasitesini kanıtlamıştır.

## 🏗️ Çözüm Mimarisi (Uçtan Uca İş Akışı)

1. **Veri Mühendisliği (PostgreSQL):** * Tarihsel kredi verileri, yapılandırılmış SQL tablolarına aktarılmıştır.
   * Gelişmiş SQL sorguları ve veri manipülasyonu ile Python modelleme ortamı için "tekil ve güvenilir bir veri kaynağı" (single source of truth) oluşturulmuştur.
2. **Özellik Mühendisliği ve Modelleme (Python / Scikit-Learn / XGBoost):**
   * Aşırı dengesiz veri seti problemi (%92 Güvenli / %8 Batık), XGBoost algoritması içindeki `scale_pos_weight=11` parametresi optimize edilerek çözülmüştür.
   * Gelir/Borç oranı, yaş ve dış büro skorları gibi özellikler üzerinden doğrusal olmayan (non-linear) müşteri davranış desenleri çıkarılmıştır.
3. **Veri Görselleştirme ve UX (Power BI):**
   * Model çıktıları ve risk kümelenmeleri, yöneticilerin bilişsel yükünü (cognitive load) azaltmak amacıyla "Dark Mode" (`#1C1C1C`) UI/UX prensipleriyle tasarlanmış interaktif bir dashboard'a dönüştürülmüştür.

## 📊 Dashboard Öne Çıkanlar
Power BI raporu, optimum kullanıcı deneyimi için navigasyon destekli üç stratejik sayfaya bölünmüştür:
* **Yönetici Özeti (Executive Summary):** Üst düzey KPI'lar (Toplam Portföy, Potansiyel Kayıp, Önlenen Kayıp) ve risk dağılımının makro görünümü.
* **Risk Derinlemesine Analiz (Risk Deep Dive):** Yüksek riskli davranışsal kümeleri (örn. Yüksek Borç vs. Yüksek Kredi Talebi) ve eğitim/meslek bazlı kategorik riskleri izole eden nokta grafikleri (scatter plot).
* **Finansal Etki (Business Impact):** Yapay zeka yatırım getirisinin (ROI) doğrudan görselleştirilmesi; geleneksel batık senaryosu ile AI tarafından önlenen kaybın yan yana karşılaştırması.

## 🚀 Projeyi Nasıl Çalıştırırsınız?
1. **Veritabanı Kurulumu:** Kendi PostgreSQL ortamınızda `Credit_Score_db.sql` dosyasını çalıştırarak şemayı ayağa kaldırın.
2. **Model Eğitimi:** Veri ön işleme, XGBoost hiperparametre optimizasyonu ve olasılık eşik (threshold) belirleme adımlarını incelemek için `Credit_Score.ipynb` dosyasını çalıştırın.
3. **Dashboard Görüntüleme:** Modelin segmente ettiği nihai çıktı dosyası (`powerbi_kredi_risk_verisi.csv`), Power BI dashboard'una entegre edilmiştir. Raporu doğrudan Power BI Desktop üzerinden inceleyebilirsiniz.

## 📬 İletişim
**Muhammed Fakılı**
* Data Scientist & AI Engineer | Building RAG & LLM Solutions | Python | Power BI
* [LinkedIn Profilim](https://www.linkedin.com/in/muhammedfakili/)
