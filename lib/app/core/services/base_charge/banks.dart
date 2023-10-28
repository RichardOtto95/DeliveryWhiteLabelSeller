import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/.info.dart';

class Banks {
  static const List<Map<String, dynamic>> banks = [
    {
      "code": "001",
      "label": "BANCO DO BRASIL S.A (BB)",
      "ispb_code": "00000000",
    },
    {
      "code": "237",
      "label": "BRADESCO S.A",
      "ispb_code": "60746948",
    },
    {
      "code": "335",
      "label": "Banco Digio S.A",
      "ispb_code": "27098060",
    },
    {
      "code": "260",
      "label": "NU PAGAMENTOS S.A (NUBANK)",
      "ispb_code": "18236120"
    },
    {
      "code": "290",
      "label": "Pagseguro Internet S.A (PagBank)",
      "ispb_code": "08561701"
    },
    {
      "code": "380",
      "label": "PicPay Servicos S.A.",
      "ispb_code": "22896431",
    },
    {
      "code": "323",
      "label": "Mercado Pago - conta do Mercado Livre",
      "ispb_code": "10573521"
    },
    {
      "code": "237",
      "label": "NEXT BANK (UTILIZAR O MESMO CÓDIGO DO BRADESCO)",
      "ispb_code": "60746948"
    },
    {
      "code": "637",
      "label": "BANCO SOFISA S.A (SOFISA DIRETO)",
      "ispb_code": "60889128"
    },
    {
      "code": "077",
      "label": "BANCO INTER S.A",
      "ispb_code": "00416968",
    },
    {
      "code": "341",
      "label": "ITAÚ UNIBANCO S.A",
      "ispb_code": "60701190",
    },
    {
      "code": "104",
      "label": "CAIXA ECONÔMICA FEDERAL (CEF)",
      "ispb_code": "00360305"
    },
    {
      "code": "033",
      "label": "BANCO SANTANDER BRASIL S.A",
      "ispb_code": "90400888"
    },
    {
      "code": "212",
      "label": "BANCO ORIGINAL S.A",
      "ispb_code": "92894922",
    },
    {
      "code": "756",
      "label": "BANCOOB (BANCO COOPERATIVO DO BRASIL)",
      "ispb_code": "02038232"
    },
    {
      "code": "655",
      "label": "BANCO VOTORANTIM S.A",
      "ispb_code": "59588111",
    },
    {
      "code": "655",
      "label": "NEON PAGAMENTOS S.A (OS MESMOS DADOS DO BANCO VOTORANTIM)",
      "ispb_code": "59588111"
    },
    {
      "code": "041",
      "label": "BANRISUL – BANCO DO ESTADO DO RIO GRANDE DO SUL S.A",
      "ispb_code": "92702067"
    },
    {
      "code": "389",
      "label": "BANCO MERCANTIL DO BRASIL S.A",
      "ispb_code": "17184037"
    },
    {
      "code": "422",
      "label": "BANCO SAFRA S.A",
      "ispb_code": "58160789",
    },
    {
      "code": "070",
      "label": "BANCO DE BRASÍLIA (BRB)",
      "ispb_code": "00000208",
    },
    {
      "code": "136",
      "label": "UNICRED COOPERATIVA",
      "ispb_code": "00315557",
    },
    {
      "code": "741",
      "label": "BANCO RIBEIRÃO PRETO",
      "ispb_code": "00517645",
    },
    {
      "code": "739",
      "label": "BANCO CETELEM S.A",
      "ispb_code": "00558456",
    },
    {
      "code": "743",
      "label": "BANCO SEMEAR S.A",
      "ispb_code": "00795423",
    },
    {
      "code": "100",
      "label": "PLANNER CORRETORA DE VALORES S.A",
      "ispb_code": "00806535"
    },
    {
      "code": "096",
      "label": "BANCO B3 S.A",
      "ispb_code": "00997185",
    },
    {
      "code": "747",
      "label": "Banco RABOBANK INTERNACIONAL DO BRASIL S.A",
      "ispb_code": "01023570"
    },
    {
      "code": "748",
      "label": "SICREDI S.A",
      "ispb_code": "01181521",
    },
    {
      "code": "752",
      "label": "BNP PARIBAS BRASIL S.A",
      "ispb_code": "01522368",
    },
    {
      "code": "091",
      "label": "UNICRED CENTRAL RS",
      "ispb_code": "01634601",
    },
    {
      "code": "399",
      "label": "KIRTON BANK",
      "ispb_code": "01701201",
    },
    {
      "code": "108",
      "label": "PORTOCRED S.A",
      "ispb_code": "01800019",
    },
    {
      "code": "757",
      "label": "BANCO KEB HANA DO BRASIL S.A",
      "ispb_code": "02318507"
    },
    {
      "code": "102",
      "label": "XP INVESTIMENTOS S.A",
      "ispb_code": "02332886",
    },
    {
      "code": "348",
      "label": "BANCO XP S/A",
      "ispb_code": "33264668",
    },
    {
      "code": "340",
      "label": "SUPER PAGAMENTOS S/A (SUPERDITAL)",
      "ispb_code": "09554480"
    },
    {
      "code": "364",
      "label": "GERENCIANET PAGAMENTOS DO BRASIL",
      "ispb_code": "09089356"
    },
    {
      "code": "084",
      "label": "UNIPRIME NORTE DO PARANÁ",
      "ispb_code": "02398976",
    },
    {
      "code": "180",
      "label": "CM CAPITAL MARKETS CCTVM LTDA",
      "ispb_code": "02685483"
    },
    {
      "code": "066",
      "label": "BANCO MORGAN STANLEY S.A",
      "ispb_code": "02801938",
    },
    {
      "code": "015",
      "label": "UBS BRASIL CCTVM S.A",
      "ispb_code": "02819125",
    },
    {
      "code": "143",
      "label": "TREVISO CC S.A",
      "ispb_code": "02992317",
    },
    {
      "code": "062",
      "label": "HIPERCARD BM S.A",
      "ispb_code": "03012230",
    },
    {
      "code": "074",
      "label": "BCO. J.SAFRA S.A",
      "ispb_code": "03017677",
    },
    {
      "code": "099",
      "label": "UNIPRIME CENTRAL CCC LTDA",
      "ispb_code": "03046391"
    },
    {
      "code": "025",
      "label": "BANCO ALFA S.A.",
      "ispb_code": "03323840",
    },
    {
      "code": "075",
      "label": "BCO ABN AMRO S.A",
      "ispb_code": "03532415",
    },
    {
      "code": "040",
      "label": "BANCO CARGILL S.A",
      "ispb_code": "03609817",
    },
    {
      "code": "190",
      "label": "SERVICOOP",
      "ispb_code": "03973814",
    },
    {
      "code": "063",
      "label": "BANCO BRADESCARD",
      "ispb_code": "04184779",
    },
    {
      "code": "191",
      "label": "NOVA FUTURA CTVM LTDA",
      "ispb_code": "04257795",
    },
    {
      "code": "064",
      "label": "GOLDMAN SACHS DO BRASIL BM S.A",
      "ispb_code": "04332281"
    },
    {
      "code": "097",
      "label": "CCC NOROESTE BRASILEIRO LTDA",
      "ispb_code": "04632856"
    },
    {
      "code": "016",
      "label": "CCM DESP TRÂNS SC E RS",
      "ispb_code": "04715685",
    },
    {
      "code": "012",
      "label": "BANCO INBURSA",
      "ispb_code": "04866275",
    },
    {
      "code": "003",
      "label": "BANCO DA AMAZONIA S.A",
      "ispb_code": "04902979",
    },
    {
      "code": "060",
      "label": "CONFIDENCE CC S.A",
      "ispb_code": "04913129",
    },
    {
      "code": "037",
      "label": "BANCO DO ESTADO DO PARÁ S.A",
      "ispb_code": "04913711"
    },
    {
      "code": "159",
      "label": "CASA CREDITO S.A",
      "ispb_code": "05442029",
    },
    {
      "code": "172",
      "label": "ALBATROSS CCV S.A",
      "ispb_code": "05452073",
    },
    {
      "code": "085",
      "label": "COOP CENTRAL AILOS",
      "ispb_code": "05463212",
    },
    {
      "code": "114",
      "label": "CENTRAL COOPERATIVA DE CRÉDITO NO ESTADO DO ESPÍRITO SANTO",
      "ispb_code": "05790149"
    },
    {
      "code": "036",
      "label": "BANCO BBI S.A",
      "ispb_code": "06271464",
    },
    {
      "code": "394",
      "label": "BANCO BRADESCO FINANCIAMENTOS S.A",
      "ispb_code": "07207996"
    },
    {
      "code": "004",
      "label": "BANCO DO NORDESTE DO BRASIL S.A.",
      "ispb_code": "07237373"
    },
    {
      "code": "320",
      "label": "BANCO CCB BRASIL S.A",
      "ispb_code": "07450604",
    },
    {
      "code": "189",
      "label": "HS FINANCEIRA",
      "ispb_code": "07512441",
    },
    {
      "code": "105",
      "label": "LECCA CFI S.A",
      "ispb_code": "07652226",
    },
    {
      "code": "076",
      "label": "BANCO KDB BRASIL S.A.",
      "ispb_code": "07656500",
    },
    {
      "code": "082",
      "label": "BANCO TOPÁZIO S.A",
      "ispb_code": "07679404",
    },
    {
      "code": "286",
      "label": "CCR DE OURO",
      "ispb_code": "07853842",
    },
    {
      "code": "093",
      "label": "PÓLOCRED SCMEPP LTDA",
      "ispb_code": "07945233",
    },
    {
      "code": "273",
      "label": "CCR DE SÃO MIGUEL DO OESTE",
      "ispb_code": "08253539"
    },
    {
      "code": "157",
      "label": "ICAP DO BRASIL CTVM LTDA",
      "ispb_code": "09105360",
    },
    {
      "code": "183",
      "label": "SOCRED S.A",
      "ispb_code": "09210106",
    },
    {
      "code": "014",
      "label": "NATIXIS BRASIL S.A",
      "ispb_code": "09274232",
    },
    {
      "code": "130",
      "label": "CARUANA SCFI",
      "ispb_code": "09313766",
    },
    {
      "code": "127",
      "label": "CODEPE CVC S.A",
      "ispb_code": "09512542",
    },
    {
      "code": "079",
      "label": "BANCO ORIGINAL DO AGRONEGÓCIO S.A",
      "ispb_code": "09516419"
    },
    {
      "code": "081",
      "label": "BBN BANCO BRASILEIRO DE NEGOCIOS S.A",
      "ispb_code": "10264663"
    },
    {
      "code": "118",
      "label": "STANDARD CHARTERED BI S.A",
      "ispb_code": "11932017"
    },
    {
      "code": "133",
      "label": "CRESOL CONFEDERAÇÃO",
      "ispb_code": "10398952",
    },
    {
      "code": "121",
      "label": "BANCO AGIBANK S.A",
      "ispb_code": "10664513",
    },
    {
      "code": "083",
      "label": "BANCO DA CHINA BRASIL S.A",
      "ispb_code": "10690848"
    },
    {
      "code": "138",
      "label": "GET MONEY CC LTDA",
      "ispb_code": "10853017",
    },
    {
      "code": "024",
      "label": "BCO BANDEPE S.A",
      "ispb_code": "10866788",
    },
    {
      "code": "095",
      "label": "BANCO CONFIDENCE DE CÂMBIO S.A",
      "ispb_code": "11703662"
    },
    {
      "code": "094",
      "label": "BANCO FINAXIS",
      "ispb_code": "11758741",
    },
    {
      "code": "276",
      "label": "SENFF S.A",
      "ispb_code": "11970623",
    },
    {
      "code": "137",
      "label": "MULTIMONEY CC LTDA",
      "ispb_code": "12586596",
    },
    {
      "code": "092",
      "label": "BRK S.A",
      "ispb_code": "12865507",
    },
    {
      "code": "047",
      "label": "BANCO BCO DO ESTADO DE SERGIPE S.A",
      "ispb_code": "13009717"
    },
    {
      "code": "144",
      "label": "BEXS BANCO DE CAMBIO S.A.",
      "ispb_code": "13059145"
    },
    {
      "code": "126",
      "label": "BR PARTNERS BI",
      "ispb_code": "13220493",
    },
    {
      "code": "301",
      "label": "BPP INSTITUIÇÃO DE PAGAMENTOS S.A",
      "ispb_code": "1,3370835"
    },
    {
      "code": "173",
      "label": "BRL TRUST DTVM SA",
      "ispb_code": "13486793",
    },
    {
      "code": "119",
      "label": "BANCO WESTERN UNION",
      "ispb_code": "13720915",
    },
    {
      "code": "254",
      "label": "PARANA BANCO S.A",
      "ispb_code": "14388334",
    },
    {
      "code": "268",
      "label": "BARIGUI CH",
      "ispb_code": "14511781",
    },
    {
      "code": "107",
      "label": "BANCO BOCOM BBM S.A",
      "ispb_code": "15114366",
    },
    {
      "code": "412",
      "label": "BANCO CAPITAL S.A",
      "ispb_code": "15173776",
    },
    {
      "code": "124",
      "label": "BANCO WOORI BANK DO BRASIL S.A",
      "ispb_code": "15357060"
    },
    {
      "code": "149",
      "label": "FACTA S.A. CFI",
      "ispb_code": "15581638",
    },
    {
      "code": "197",
      "label": "STONE PAGAMENTOS S.A",
      "ispb_code": "16501555",
    },
    {
      "code": "142",
      "label": "BROKER BRASIL CC LTDA",
      "ispb_code": "16944141",
    },
    {
      "code": "389",
      "label": "BANCO MERCANTIL DO BRASIL S.A.",
      "ispb_code": "17184037"
    },
    {
      "code": "184",
      "label": "BANCO ITAÚ BBA S.A",
      "ispb_code": "17298092",
    },
    {
      "code": "634",
      "label": "BANCO TRIANGULO S.A (BANCO TRIÂNGULO)",
      "ispb_code": "17351180"
    },
    {
      "code": "545",
      "label": "SENSO CCVM S.A",
      "ispb_code": "17352220",
    },
    {
      "code": "132",
      "label": "ICBC DO BRASIL BM S.A",
      "ispb_code": "17453575",
    },
    {
      "code": "298",
      "label": "VIPS CC LTDA",
      "ispb_code": "17772370",
    },
    {
      "code": "129",
      "label": "UBS BRASIL BI S.A",
      "ispb_code": "18520834",
    },
    {
      "code": "128",
      "label": "MS BANK S.A BANCO DE CÂMBIO",
      "ispb_code": "19307785"
    },
    {
      "code": "194",
      "label": "PARMETAL DTVM LTDA",
      "ispb_code": "20155248",
    },
    {
      "code": "310",
      "label": "VORTX DTVM LTDA",
      "ispb_code": "22610500",
    },
    {
      "code": "163",
      "label": "COMMERZBANK BRASIL S.A BANCO MÚLTIPLO",
      "ispb_code": "23522214"
    },
    {
      "code": "280",
      "label": "AVISTA S.A",
      "ispb_code": "23862762",
    },
    {
      "code": "146",
      "label": "GUITTA CC LTDA",
      "ispb_code": "24074692",
    },
    {
      "code": "279",
      "label": "CCR DE PRIMAVERA DO LESTE",
      "ispb_code": "26563270"
    },
    {
      "code": "182",
      "label": "DACASA FINANCEIRA S/A",
      "ispb_code": "27406222",
    },
    {
      "code": "278",
      "label": "GENIAL INVESTIMENTOS CVM S.A",
      "ispb_code": "27652684"
    },
    {
      "code": "271",
      "label": "IB CCTVM LTDA",
      "ispb_code": "27842177",
    },
    {
      "code": "021",
      "label": "BANCO BANESTES S.A",
      "ispb_code": "28127603",
    },
    {
      "code": "246",
      "label": "BANCO ABC BRASIL S.A",
      "ispb_code": "28195667",
    },
    {
      "code": "751",
      "label": "SCOTIABANK BRASIL",
      "ispb_code": "29030467",
    },
    {
      "code": "208",
      "label": "BANCO BTG PACTUAL S.A",
      "ispb_code": "30306294",
    },
    {
      "code": "746",
      "label": "BANCO MODAL S.A",
      "ispb_code": "30723886",
    },
    {
      "code": "241",
      "label": "BANCO CLASSICO S.A",
      "ispb_code": "31597552",
    },
    {
      "code": "612",
      "label": "BANCO GUANABARA S.A",
      "ispb_code": "31880826",
    },
    {
      "code": "604",
      "label": "BANCO INDUSTRIAL DO BRASIL S.A",
      "ispb_code": "31895683"
    },
    {
      "code": "505",
      "label": "BANCO CREDIT SUISSE (BRL) S.A",
      "ispb_code": "32062580"
    },
    {
      "code": "196",
      "label": "BANCO FAIR CC S.A",
      "ispb_code": "32648370",
    },
    {
      "code": "300",
      "label": "BANCO LA NACION ARGENTINA",
      "ispb_code": "33042151"
    },
    {
      "code": "477",
      "label": "CITIBANK N.A",
      "ispb_code": "33042953",
    },
    {
      "code": "266",
      "label": "BANCO CEDULA S.A",
      "ispb_code": "33132044",
    },
    {
      "code": "122",
      "label": "BANCO BRADESCO BERJ S.A",
      "ispb_code": "33147315",
    },
    {
      "code": "376",
      "label": "BANCO J.P. MORGAN S.A",
      "ispb_code": "33172537",
    },
    {
      "code": "473",
      "label": "BANCO CAIXA GERAL BRASIL S.A",
      "ispb_code": "33466988"
    },
    {
      "code": "745",
      "label": "BANCO CITIBANK S.A",
      "ispb_code": "33479023",
    },
    {
      "code": "120",
      "label": "BANCO RODOBENS S.A",
      "ispb_code": "33603457",
    },
    {
      "code": "265",
      "label": "BANCO FATOR S.A",
      "ispb_code": "33644196",
    },
    {
      "code": "007",
      "label": "BNDES (Banco Nacional do Desenvolvimento Social)",
      "ispb_code": "33657248"
    },
    {
      "code": "188",
      "label": "ATIVA S.A INVESTIMENTOS",
      "ispb_code": "33775974",
    },
    {
      "code": "134",
      "label": "BGC LIQUIDEZ DTVM LTDA",
      "ispb_code": "33862244",
    },
    {
      "code": "641",
      "label": "BANCO ALVORADA S.A",
      "ispb_code": "33870163",
    },
    {
      "code": "029",
      "label": "BANCO ITAÚ CONSIGNADO S.A",
      "ispb_code": "33885724"
    },
    {
      "code": "243",
      "label": "BANCO MÁXIMA S.A",
      "ispb_code": "33923798",
    },
    {
      "code": "078",
      "label": "HAITONG BI DO BRASIL S.A",
      "ispb_code": "34111187",
    },
    {
      "code": "111",
      "label": "BANCO OLIVEIRA TRUST DTVM S.A",
      "ispb_code": "36113876"
    },
    {
      "code": "017",
      "label": "BNY MELLON BANCO S.A",
      "ispb_code": "42272526",
    },
    {
      "code": "174",
      "label": "PERNAMBUCANAS FINANC S.A",
      "ispb_code": "43180355",
    },
    {
      "code": "495",
      "label": "LA PROVINCIA BUENOS AIRES BANCO",
      "ispb_code": "44189447"
    },
    {
      "code": "125",
      "label": "BRASIL PLURAL S.A BANCO",
      "ispb_code": "45246410",
    },
    {
      "code": "488",
      "label": "JPMORGAN CHASE BANK",
      "ispb_code": "46518205",
    },
    {
      "code": "065",
      "label": "BANCO ANDBANK S.A",
      "ispb_code": "48795256",
    },
    {
      "code": "492",
      "label": "ING BANK N.V",
      "ispb_code": "49336860",
    },
    {
      "code": "250",
      "label": "BANCO BCV",
      "ispb_code": "50585090",
    },
    {
      "code": "145",
      "label": "LEVYCAM CCV LTDA",
      "ispb_code": "50579044",
    },
    {
      "code": "494",
      "label": "BANCO REP ORIENTAL URUGUAY",
      "ispb_code": "51938876"
    },
    {
      "code": "253",
      "label": "BEXS CC S.A",
      "ispb_code": "52937216",
    },
    {
      "code": "269",
      "label": "HSBC BANCO DE INVESTIMENTO",
      "ispb_code": "53518684"
    },
    {
      "code": "213",
      "label": "BCO ARBI S.A",
      "ispb_code": "54403563",
    },
    {
      "code": "139",
      "label": "INTESA SANPAOLO BRASIL S.A",
      "ispb_code": "55230916"
    },
    {
      "code": "018",
      "label": "BANCO TRICURY S.A",
      "ispb_code": "57839805",
    },
    {
      "code": "630",
      "label": "BANCO INTERCAP S.A",
      "ispb_code": "58497702",
    },
    {
      "code": "224",
      "label": "BANCO FIBRA S.A",
      "ispb_code": "58616418",
    },
    {
      "code": "600",
      "label": "BANCO LUSO BRASILEIRO S.A",
      "ispb_code": "59118133"
    },
    {
      "code": "623",
      "label": "BANCO PAN",
      "ispb_code": "59285411",
    },
    {
      "code": "204",
      "label": "BANCO BRADESCO CARTOES S.A",
      "ispb_code": "59438325"
    },
    {
      "code": "479",
      "label": "BANCO ITAUBANK S.A",
      "ispb_code": "60394079",
    },
    {
      "code": "456",
      "label": "BANCO MUFG BRASIL S.A",
      "ispb_code": "60498557",
    },
    {
      "code": "464",
      "label": "BANCO SUMITOMO MITSUI BRASIL S.A",
      "ispb_code": "60518222"
    },
    {
      "code": "613",
      "label": "OMNI BANCO S.A",
      "ispb_code": "60850229",
    },
    {
      "code": "652",
      "label": "ITAÚ UNIBANCO HOLDING BM S.A",
      "ispb_code": "60872504"
    },
    {
      "code": "653",
      "label": "BANCO INDUSVAL S.A",
      "ispb_code": "61024352",
    },
    {
      "code": "069",
      "label": "BANCO CREFISA S.A",
      "ispb_code": "61033106",
    },
    {
      "code": "370",
      "label": "BANCO MIZUHO S.A",
      "ispb_code": "61088183",
    },
    {
      "code": "249",
      "label": "BANCO INVESTCRED UNIBANCO S.A",
      "ispb_code": "61182408"
    },
    {
      "code": "318",
      "label": "BANCO BMG S.A",
      "ispb_code": "61186680",
    },
    {
      "code": "626",
      "label": "BANCO FICSA S.A",
      "ispb_code": "61348538",
    },
    {
      "code": "270",
      "label": "SAGITUR CC LTDA",
      "ispb_code": "61444949",
    },
    {
      "code": "366",
      "label": "BANCO SOCIETE GENERALE BRASIL",
      "ispb_code": "61533584"
    },
    {
      "code": "113",
      "label": "MAGLIANO S.A",
      "ispb_code": "61723847",
    },
    {
      "code": "131",
      "label": "TULLETT PREBON BRASIL CVC LTDA",
      "ispb_code": "61747085"
    },
    {
      "code": "011",
      "label": "C.SUISSE HEDGING-GRIFFO CV S.A (Credit Suisse)",
      "ispb_code": "61809182"
    },
    {
      "code": "611",
      "label": "BANCO PAULISTA",
      "ispb_code": "61820817",
    },
    {
      "code": "755",
      "label": "BOFA MERRILL LYNCH BM S.A",
      "ispb_code": "62073200"
    },
    {
      "code": "089",
      "label": "CCR REG MOGIANA",
      "ispb_code": "62109566",
    },
    {
      "code": "643",
      "label": "BANCO PINE S.A",
      "ispb_code": "62144175",
    },
    {
      "code": "140",
      "label": "EASYNVEST - TÍTULO CV S.A",
      "ispb_code": "62169875"
    },
    {
      "code": "707",
      "label": "BANCO DAYCOVAL S.A",
      "ispb_code": "62232889",
    },
    {
      "code": "288",
      "label": "CAROL DTVM LTDA",
      "ispb_code": "62237649",
    },
    {
      "code": "101",
      "label": "RENASCENCA DTVM LTDA",
      "ispb_code": "62287735",
    },
    {
      "code": "487",
      "label": "DEUTSCHE BANK S.A BANCO ALEMÃO",
      "ispb_code": "62331228"
    },
    {
      "code": "233",
      "label": "BANCO CIFRA",
      "ispb_code": "62421979",
    },
    {
      "code": "177",
      "label": "GUIDE",
      "ispb_code": "65913436",
    },
    {
      "code": "633",
      "label": "BANCO RENDIMENTO S.A",
      "ispb_code": "68900810",
    },
    {
      "code": "218",
      "label": "BANCO BS2 S.A",
      "ispb_code": "71027866",
    },
    {
      "code": "292",
      "label": "BS2 DISTRIBUIDORA DE TÍTULOS E INVESTIMENTOS",
      "ispb_code": "28650236"
    },
    {
      "code": "169",
      "label": "BANCO OLÉ BONSUCESSO CONSIGNADO S.A",
      "ispb_code": "71371686"
    },
    {
      "code": "293",
      "label": "LASTRO RDV DTVM LTDA",
      "ispb_code": "71590442",
    },
    {
      "code": "285",
      "label": "FRENTE CC LTDA",
      "ispb_code": "71677850",
    },
    {
      "code": "080",
      "label": "B&T CC LTDA",
      "ispb_code": "73622748",
    },
    {
      "code": "753",
      "label": "NOVO BANCO CONTINENTAL S.A BM",
      "ispb_code": "74828799"
    },
    {
      "code": "222",
      "label": "BANCO CRÉDIT AGRICOLE BR S.A",
      "ispb_code": "75647891"
    },
    {
      "code": "754",
      "label": "BANCO SISTEMA",
      "ispb_code": "76543115",
    },
    {
      "code": "098",
      "label": "CREDIALIANÇA CCR",
      "ispb_code": "78157146",
    },
    {
      "code": "610",
      "label": "BANCO VR S.A",
      "ispb_code": "78626983",
    },
    {
      "code": "712",
      "label": "BANCO OURINVEST S.A",
      "ispb_code": "78632767",
    },
    {
      "code": "010",
      "label": "CREDICOAMO",
      "ispb_code": "81723108",
    },
    {
      "code": "283",
      "label": "RB CAPITAL INVESTIMENTOS DTVM LTDA",
      "ispb_code": "89960090"
    },
    {
      "code": "217",
      "label": "BANCO JOHN DEERE S.A",
      "ispb_code": "91884981",
    },
    {
      "code": "117",
      "label": "ADVANCED CC LTDA",
      "ispb_code": "92856905",
    },
    {
      "code": "336",
      "label": "BANCO C6 S.A - C6 BANK",
      "ispb_code": "28326000",
    },
    {
      "code": "654",
      "label": "BANCO DIGIMAIS S.A",
      "ispb_code": "92874270",
    },
  ];

  Future<void> updateBanks() async {
    for (Map<String, dynamic> bank in banks) {
      print("bank: $bank");
      final bankRef = FirebaseFirestore.instance
          .collection("info")
          .doc(infoId)
          .collection("banks")
          .doc();

      bank["id"] = bankRef.id;

      await bankRef.set(bank);
    }
  }
}
