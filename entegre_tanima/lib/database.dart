class ElektronikParca {
  final String kod;          // Kameranın okuyacağı kod (Örn: "NE555")
  final String kategori;     // Entegre, Transistör veya Regülatör
  final String isim;         // Kısa görevi (Örn: "Zamanlayıcı (Timer)")
  final String aciklama;     // Teknik detaylar
  final String datasheetUrl; // PDF linki (İnternetten açmak için)
  final String pinoutGorseli;// Bacak yapısı resmi (İleride ekleriz)

  ElektronikParca({
    required this.kod,
    required this.kategori,
    required this.isim,
    required this.aciklama,
    required this.datasheetUrl,
    required this.pinoutGorseli,
  });
}
List<ElektronikParca> parcaVeritabani = [
  // --- ENTEGRELER (IC) ---
  ElektronikParca(
    kod: "74HC08",
    kategori: "Lojik Entegre",
    isim: "Dörtlü 2 Girişli VE (AND) Kapısı",
    aciklama: "İçerisinde 4 adet bağımsız 2 girişli AND (VE) kapısı barındıran yüksek hızlı CMOS lojik entegresidir. Sadece her iki giriş de HIGH (1) olduğunda çıkış HIGH (1) olur, diğer tüm durumlarda LOW (0) verir.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/sn74hc08.pdf",
    pinoutGorseli: "assets/images/74hc08_pinout.png", 
  ),

  ElektronikParca(
    kod: "74S86",
    kategori: "Lojik Entegre",
    isim: "Dörtlü 2 Girişli Özel VEYA (XOR) Kapısı",
    aciklama: "İçerisinde 4 adet bağımsız 2 girişli XOR (Özel VEYA) kapısı bulundurur. Sadece iki giriş birbirinden FARKLI olduğunda (biri 1, diğeri 0) çıkış HIGH (1) değerini verir. Girişler aynıysa çıkış LOW (0) olur.",
    datasheetUrl: "https://www.ti.com/lit/gpn/SN74LS86A",
    pinoutGorseli: "assets/images/74s86_pinout.png", 
  ),
  
  ElektronikParca(
    kod: "NE555",
    kategori: "Entegre",
    isim: "Hassas Zamanlayıcı (Timer)",
    aciklama: "Osilatör, darbe üretici ve zamanlayıcı devrelerinde kullanılan efsanevi 8 bacaklı entegre. Maksimum 15V-18V arası çalışır.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/ne555.pdf",
    pinoutGorseli: "assets/images/ne555_pinout.png",
  ),
  ElektronikParca(
    kod: "LM358",
    kategori: "Entegre",
    isim: "Çift İşlemsel Yükselteç (Op-Amp)",
    aciklama: "İçerisinde iki adet bağımsız op-amp barındırır. Sensör sinyallerini yükseltmek ve karşılaştırıcı (comparator) olarak kullanılır.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/lm358.pdf",
    pinoutGorseli: "assets/images/lm358_pinout.png",
  ),
  ElektronikParca(
    kod: "ATMEGA328P",
    kategori: "Entegre",
    isim: "8-bit Mikrodenetleyici",
    aciklama: "Arduino Uno'nun beyni olan 28 pinli mikrodenetleyicidir. 32KB Flash belleği vardır.",
    datasheetUrl: "https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf",
    pinoutGorseli: "assets/images/atmega_pinout.png",
  ),
  ElektronikParca(
    kod: "74LS08",
    kategori: "Entegre",
    isim: "Dörtlü 2-Girişli AND Kapısı",
    aciklama: "Lojik devre tasarımlarında kullanılan, içinde 4 adet VE (AND) kapısı bulunduran standart TTL entegresi.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/sn74ls08.pdf",
    pinoutGorseli: "assets/images/74ls08_pinout.png",
  ),
  ElektronikParca(
    kod: "L293D",
    kategori: "Entegre",
    isim: "Motor Sürücü (H-Köprüsü)",
    aciklama: "Aynı anda 2 adet DC motoru çift yönlü sürmek için kullanılır. Robotik projelerin vazgeçilmezidir.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/l293d.pdf",
    pinoutGorseli: "assets/images/l293d_pinout.png",
  ),

  // --- VOLTAJ REGÜLATÖRLERİ ---
  ElektronikParca(
    kod: "7805",
    kategori: "Regülatör",
    isim: "5V Pozitif Voltaj Regülatörü",
    aciklama: "Girişine verilen 7V-35V arası DC gerilimi sabit 5V'a düşürür. Sensör ve mikrodenetleyici beslemeleri için idealdir.",
    datasheetUrl: "https://www.sparkfun.com/datasheets/Components/LM7805.pdf",
    pinoutGorseli: "assets/images/7805_pinout.png",
  ),
  ElektronikParca(
    kod: "LM317",
    kategori: "Regülatör",
    isim: "Ayarlanabilir Voltaj Regülatörü",
    aciklama: "Dirençlerle ayarlanarak 1.25V ile 37V arası istenilen voltajı verebilen güç kaynağı elemanı.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/lm317.pdf",
    pinoutGorseli: "assets/images/lm317_pinout.png",
  ),

  // --- TRANSİSTÖRLER ---
  ElektronikParca(
    kod: "BC547",
    kategori: "Transistör",
    isim: "NPN Bipolar Transistör (BJT)",
    aciklama: "Genel amaçlı anahtarlama ve sinyal yükseltme işlerinde kullanılan, elektronik dünyasının en bilindik transistörü.",
    datasheetUrl: "https://www.sparkfun.com/datasheets/Components/BC546.pdf",
    pinoutGorseli: "assets/images/bc547_pinout.png",
  ),
  ElektronikParca(
    kod: "TIP120",
    kategori: "Transistör",
    isim: "NPN Darlington Güç Transistörü",
    aciklama: "Arduino gibi düşük akımlı kaynaklarla yüksek akım çeken DC motorları veya şerit LED'leri sürmek için kullanılır.",
    datasheetUrl: "https://www.onsemi.com/pdf/datasheet/tip120-d.pdf",
    pinoutGorseli: "assets/images/tip120_pinout.png",
  ),
  ElektronikParca(
    kod: "IRFZ44N",
    kategori: "Transistör",
    isim: "N-Kanal Güç MOSFET'i",
    aciklama: "Çok yüksek akımları (49 Amper'e kadar) anahtarlamak için kullanılan güçlü bir MOSFET.",
    datasheetUrl: "https://www.infineon.com/dgdl/irfz44n.pdf",
    pinoutGorseli: "assets/images/irfz44n_pinout.png",
  ),
];