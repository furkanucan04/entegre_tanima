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
  ElektronikParca(
    kod: "74HC595",
    kategori: "Entegre (Shift Register)",
    isim: "8-Bit Seri Girişli, Paralel Çıkışlı Kaydırmalı Kaydedici",
    aciklama: "Arduino gibi mikrodenetleyicilerde pin sayısını artırmak için kullanılan, 8 adet çıkışı sadece 3 pin ile kontrol etmeyi sağlayan efsanevi entegre.",
    datasheetUrl: "https://www.nxp.com/docs/en/data-sheet/74HC_HCT595.pdf",
    pinoutGorseli: "assets/images/74hc595_pinout.png",
  ),
  ElektronikParca(
    kod: "ULN2003",
    kategori: "Entegre (Motor Sürücü)",
    isim: "Yüksek Akım/Gerilim Darlington Transistör Dizisi",
    aciklama: "Mikrodenetleyicilerin çıkış akımının yetmediği durumlarda, step motorları, röleleri ve yüksek güçlü LED'leri sürmek için kullanılan 7 kanallı bir sürücü entegresidir. İçindeki ters diyotlar endüktif yükleri korur.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/uln2003a.pdf",
    pinoutGorseli: "assets/images/uln2003_pinout.png",
  ),
  ElektronikParca(
    kod: "UA741",
    kategori: "Entegre (Analog)",
    isim: "Genel Amaçlı Operasyonel Amplifikatör (Op-Amp)",
    aciklama: "Analog elektronik derslerinin temel taşıdır. Sinyal yükseltme, karşılaştırma, toplama/çıkarma ve filtreleme işlemlerinde kullanılan klasik tekli op-amp entegresidir. Kısa devre korumasına sahiptir.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/ua741.pdf",
    pinoutGorseli: "assets/images/ua741_pinout.png",
  ),
  ElektronikParca(
    kod: "TCRT5000",
    kategori: "Sensör (Optoelektronik)",
    isim: "Kızılötesi Yansımalı Sensör (Çizgi Sensörü)",
    aciklama: "İçinde bir adet IR (kızılötesi) verici diyot ve bir adet fototransistör barındırır. Çizgi izleyen robotlarda, siyah-beyaz yüzey algılamada ve mesafe/konum tespiti projelerinde sıklıkla tercih edilir.",
    datasheetUrl: "https://www.vishay.com/docs/83760/tcrt5000.pdf",
    pinoutGorseli: "assets/images/tcrt5000_pinout.png",
  ),
  ElektronikParca(
    kod: "MAX485",
    kategori: "Entegre (Haberleşme)",
    isim: "Düşük Güçlü RS-485/RS-422 Alıcı-Verici Entegresi",
    aciklama: "Haberleşme projelerinde uzun mesafelerde (1200 metreye kadar) gürültüsüz veri aktarımı sağlamak için diferansiyel sinyal kullanan, yarı-dubleks (half-duplex) çalışan endüstriyel haberleşme entegresidir.",
    datasheetUrl: "https://datasheets.maximintegrated.com/en/ds/MAX1487-MAX491.pdf",
    pinoutGorseli: "assets/images/max485_pinout.png",
  ),
  // --- LOJİK ENTEGRELER ---
  ElektronikParca(
    kod: "74LS32",
    kategori: "Entegre (Lojik)",
    isim: "Dörtlü 2-Girişli OR (VEYA) Kapısı",
    aciklama: "Dijital elektronik tasarımında kullanılan, içerisinde 4 bağımsız VEYA kapısı barındıran standart TTL entegresi.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/sn74ls32.pdf",
    pinoutGorseli: "assets/images/74ls32_pinout.png",
  ),
  ElektronikParca(
    kod: "74LS04",
    kategori: "Entegre (Lojik)",
    isim: "Altılı NOT (DEĞİL) Kapısı / Inverter",
    aciklama: "Girişine gelen mantıksal sinyalin tersini (0 ise 1, 1 ise 0) alan 6 adet bağımsız evirici kapı barındıran entegre.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/sn74ls04.pdf",
    pinoutGorseli: "assets/images/74ls04_pinout.png",
  ),
  ElektronikParca(
    kod: "74LS00",
    kategori: "Entegre (Lojik)",
    isim: "Dörtlü 2-Girişli NAND (VE DEĞİL) Kapısı",
    aciklama: "Evrensel kapı olarak bilinen ve sadece kendisi kullanılarak tüm lojik devrelerin tasarlanabildiği 4'lü VE DEĞİL kapısı entegresi.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/sn74ls00.pdf",
    pinoutGorseli: "assets/images/74ls00_pinout.png",
  ),
  ElektronikParca(
    kod: "74LS86",
    kategori: "Entegre (Lojik)",
    isim: "Dörtlü 2-Girişli XOR (ÖZEL VEYA) Kapısı",
    aciklama: "Girişleri birbirinden farklı olduğunda 1 çıkışı veren, toplama ve karşılaştırma devrelerinde sıkça kullanılan 4'lü XOR entegresi.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/sn74ls86.pdf",
    pinoutGorseli: "assets/images/74ls86_pinout.png",
  ),
  // --- MİKRODENETLEYİCİLER VE İLETİŞİM ---
  ElektronikParca(
    kod: "ATTINY85",
    kategori: "Entegre (Mikrodenetleyici)",
    isim: "8-Bit AVR Mikrodenetleyici (8 Pin)",
    aciklama: "Küçük boyutlu projelerde Arduino yerine kullanılan, 8 bacaklı, 8KB flash belleğe sahip mini ve oldukça popüler bir mikrokontrolcü.",
    datasheetUrl: "https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-2586-AVR-8-bit-Microcontroller-ATtiny25-ATtiny45-ATtiny85_Datasheet.pdf",
    pinoutGorseli: "assets/images/attiny85_pinout.png",
  ),
  ElektronikParca(
    kod: "CH340G",
    kategori: "Entegre (Haberleşme)",
    isim: "USB - Seri (UART) Dönüştürücü Entegre",
    aciklama: "Klon Arduino Uno ve Nano kartlarında bilgisayar ile mikrodenetleyici arasında USB üzerinden haberleşme sağlayan köprü entegresi.",
    datasheetUrl: "https://www.sparkfun.com/datasheets/CH340DS1.PDF",
    pinoutGorseli: "assets/images/ch340g_pinout.png",
  ),
  // --- ANALOG VE SES ENTEGRELERİ ---
  ElektronikParca(
    kod: "LM386",
    kategori: "Entegre (Ses Amplifikatörü)",
    isim: "Düşük Voltaj Ses Güç Amplifikatörü",
    aciklama: "Küçük radyolar, hoparlörler ve ses projelerinde kullanılan, az pil tüketen, kazancı dahili olarak ayarlanan popüler ses yükseltici entegre.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/lm386.pdf",
    pinoutGorseli: "assets/images/lm386_pinout.png",
  ),
  ElektronikParca(
    kod: "TL072",
    kategori: "Entegre (Analog)",
    isim: "JFET Girişli Çift İşlemsel Yükselteç (Op-Amp)",
    aciklama: "Ses sistemlerinde ve amfilerde gürültüyü ve harmonik bozulmayı minimuma indirmek için tercih edilen yüksek kaliteli çift op-amp.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/tl072.pdf",
    pinoutGorseli: "assets/images/tl072_pinout.png",
  ),
  ElektronikParca(
    kod: "LM393",
    kategori: "Entegre (Analog)",
    isim: "Çift Voltaj Karşılaştırıcı (Comparator)",
    aciklama: "İki farklı analog voltaj değerini birbiriyle kıyaslayıp dijital (0 veya 1) çıkış üreten, sensör modüllerinde çok sık kullanılan entegre.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/lm393.pdf",
    pinoutGorseli: "assets/images/lm393_pinout.png",
  ),
  // --- GÜÇ VE SÜRÜCÜ ELEMANLARI ---
  ElektronikParca(
    kod: "L298N",
    kategori: "Entegre (Motor Sürücü)",
    isim: "Çift H-Köprüsü Güç Sürücüsü",
    aciklama: "Yüksek akımlı DC motorları ve step motorları yön ve hız (PWM) kontrollü sürmek için kullanılan, soğutuculu modüllerde sıkça gördüğümüz entegre.",
    datasheetUrl: "https://www.st.com/resource/en/datasheet/l298.pdf",
    pinoutGorseli: "assets/images/l298n_pinout.png",
  ),
  ElektronikParca(
    kod: "SG3525",
    kategori: "Entegre (Güç Yönetimi)",
    isim: "PWM Kontrolör Entegresi",
    aciklama: "Güç kaynaklarında, invertör tasarımlarında ve anahtarlamalı güç devrelerinde (SMPS) frekans ve darbe genişliği ayarlayan kontrol entegresi.",
    datasheetUrl: "https://www.onsemi.com/pdf/datasheet/sg3525a-d.pdf",
    pinoutGorseli: "assets/images/sg3525_pinout.png",
  ),
  // --- TRANSİSTÖR VE SENSÖRLER ---
  ElektronikParca(
    kod: "2N2222",
    kategori: "Transistör",
    isim: "NPN Genel Amaçlı Amplifikatör Transistörü",
    aciklama: "BC547 gibi düşük güç uygulamalarında, anahtarlama devrelerinde ve küçük sinyal yükseltmede kullanılan çok yaygın bir metal/plastik kılıf transistör.",
    datasheetUrl: "https://www.onsemi.com/pdf/datasheet/p2n2222a-d.pdf",
    pinoutGorseli: "assets/images/2n2222_pinout.png",
  ),
  ElektronikParca(
    kod: "IRF540N",
    kategori: "Transistör",
    isim: "N-Kanal Güç MOSFET'i",
    aciklama: "Hızlı anahtarlama performansı ve çok düşük direnç değeriyle DC motor hız kontrollerinde, solenoid ve yüksek güçlü yüklerin yönetiminde kullanılır.",
    datasheetUrl: "https://www.infineon.com/dgdl/Infenion-IRF540N-DataSheet-v01_01-EN.pdf",
    pinoutGorseli: "assets/images/irf540n_pinout.png",
  ),
  ElektronikParca(
    kod: "LDR",
    kategori: "Sensör (Işık)",
    isim: "Işığa Bağımlı Direnç (Foto direnç)",
    aciklama: "Üzerine düşen ışık miktarı arttıkça direnç değeri azalan, gece lambaları ve ışık algılama projelerinde kullanılan analog sensör elemanı.",
    datasheetUrl: "https://www.sparkfun.com/datasheets/Sensors/COTS-Photocell.pdf",
    pinoutGorseli: "assets/images/ldr_pinout.png",
  ),
  ElektronikParca(
    kod: "LM35",
    kategori: "Sensör (Sıcaklık)",
    isim: "Hassas Santigrat Sıcaklık Sensörü",
    aciklama: "Her 1 derece sıcaklık artışına karşılık çıkışında 10mV analog voltaj veren, kalibrasyon gerektirmeyen üç bacaklı sıcaklık sensörü.",
    datasheetUrl: "https://www.ti.com/lit/ds/symlink/lm35.pdf",
    pinoutGorseli: "assets/images/lm35_pinout.png",
  ),
];