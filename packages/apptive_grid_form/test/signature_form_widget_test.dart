import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hand_signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'common.dart';

void main() {
  final action = ApptiveLink(uri: Uri.parse('formAction'), method: 'POST');
  const field =
      GridField(id: 'fieldId', name: 'name', type: DataType.signature);
  const svgString = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg width="291.6666717529297" height="112.33332824707031" xmlns="http://www.w3.org/2000/svg">
<g fill="#000000">
<path d="M 61.517059817199986 16.52000000843297 C 61.517059817199986 16.846000008851494 61.517059817199986 18.747671415387842 61.517059817199986 21.798099990732627 C 61.517059817199986 23.83948248541883 61.28129195975444 26.726911060554354 61.28129195975444 30.18095714435189 C 61.28129195975444 33.231385719696675 61.010595664077414 35.847142890326054 61.010595664077414 39.805714323979586 C 61.010595664077414 43.259760407777115 60.69623852081669 47.427903270271145 60.69623852081669 50.982857195471944 C 60.69623852081669 54.94142862912548 60.41680981578746 57.968579307014316 60.41680981578746 60.91810004095584 C 60.41680981578746 64.47305396615664 60.47409493291173 66.34366046182686 60.47409493291173 68.9904715287189 C 60.47409493291173 71.93999226266043 60.574273753418325 74.19095400304678 60.574273753418325 76.13142865632972 C 60.574273753418325 78.77823972322176 60.71398790607005 79.46127798660214 60.71398790607005 81.0990429728356 C 60.71398790607005 83.03951762611855 60.827506029842496 83.69929362576232 60.827506029842496 85.13524292918926 C 60.827506029842496 86.77300791542271 60.923559334910536 87.11451763135014 60.923559334910536 88.5504715538305 C 60.923559334910536 89.98642085725744 61.019613039704346 90.42885724611367 61.019613039704346 91.96571439094389 C 61.019613039704346 93.40166831342425 61.05901642310623 94.0536683142613 61.05901642310623 95.69142868144132 C 61.05901642310623 97.22828582627152 61.04609793079252 98.0898494390894 61.04609793079252 99.72761442532284 C 61.04609793079252 101.36537479250288 61.01987324154149 102.32786507824957 61.01987324154149 103.76381438167651 C 61.01987324154149 105.40157936790996 61.08581839294421 105.33947157538464 61.08581839294421 107.17904300631776 C 61.08581839294421 108.61499230974466 61.20238367504575 110.6020430107123 61.20238367504575 111.83618586943956 C 61.20238367504575 111.83618586943956 61.28097296086093 114.63047158731264 61.28097296086093 114.63047158731264 L 52.48285563328769 114.63047158731264 C 52.48285563328769 114.63047158731264 52.56144491910287 111.83618586943956 52.56144491910287 111.83618586943956 C 52.56144491910287 110.6020430107123 52.67801020120441 108.61499230974466 52.67801020120441 107.17904300631776 C 52.67801020120441 105.33947157538464 52.74395535260713 105.40157936790996 52.74395535260713 103.76381438167651 C 52.74395535260713 102.32786507824957 52.7177306633561 101.36537479250288 52.7177306633561 99.72761442532284 C 52.7177306633561 98.0898494390894 52.70481217104239 97.22828582627152 52.70481217104239 95.69142868144132 C 52.70481217104239 94.0536683142613 52.744215554444274 93.40166831342425 52.744215554444274 91.96571439094389 C 52.744215554444274 90.42885724611367 52.840269259238084 89.98642085725744 52.840269259238084 88.5504715538305 C 52.840269259238084 87.11451763135014 52.936322564306124 86.77300791542271 52.936322564306124 85.13524292918926 C 52.936322564306124 83.69929362576232 53.04984068807857 83.03951762611855 53.04984068807857 81.0990429728356 C 53.04984068807857 79.46127798660214 53.189554840730295 78.77823972322176 53.189554840730295 76.13142865632972 C 53.189554840730295 74.19095400304678 53.28973366123689 71.93999226266043 53.28973366123689 68.9904715287189 C 53.28973366123689 66.34366046182686 53.34701877836116 64.47305396615664 53.34701877836116 60.91810004095584 C 53.34701877836116 57.968579307014316 53.06759007333193 54.94142862912548 53.06759007333193 50.982857195471944 C 53.06759007333193 47.427903270271145 52.753232930071206 43.259760407777115 52.753232930071206 39.805714323979586 C 52.753232930071206 35.847142890326054 52.48253663439418 33.231385719696675 52.48253663439418 30.18095714435189 C 52.48253663439418 26.726911060554354 52.246768776948635 23.83948248541883 52.246768776948635 21.798099990732627 C 52.246768776948635 18.747671415387842 52.246768776948635 16.84600000872663 52.246768776948635 16.520000008308106 z" />
<circle cx="56.88191429707431" cy="16.520000008370538" r="4.635145520125674" />
<circle cx="56.88191429707431" cy="114.63047158731264" r="4.399058663786621" />
<path d="M 9.999999999970175 7.774269934846186 C 10.326000000388703 7.774269934846186 10.041524188943269 7.695680649031004 12.79428571787668 7.695680649031004 C 14.028428576603957 7.695680649031004 16.520011023038304 7.940180915828752 21.487628537350425 7.940180915828752 C 24.638964954098476 7.940180915828752 30.196482493581623 8.341859354531081 35.76952858009957 8.341859354531081 C 40.73714609441169 8.341859354531081 47.1484746984854 8.795930650443534 51.91428576809786 8.795930650443534 C 57.48733185461582 8.795930650443534 61.17847816648417 9.165300300364319 65.54164212175186 9.117239558071274 C 70.30703679769535 9.05624188251698 73.92950749976032 9.063122255664787 77.80218991597897 8.818524082993399 C 82.15458939597593 8.512942501376514 85.60759720139879 7.813762345489163 88.55012786891218 7.519175391907959 C 92.41275322604395 7.14621309214872 94.82012063491158 6.7613819752819655 96.75780764621092 6.659585428917424 C 99.71210528194851 6.534427443791774 100.46530692184196 6.515262372014276 101.90126084432234 6.515262372014276 C 103.84173549760527 6.515262372014276 103.88025077011422 6.419208653994538 105.31620007354115 6.419208653994538 C 106.75215399602153 6.419208653994538 107.39637799805185 6.323155348926503 108.7314286981824 6.323155348926503 C 110.16737800160932 6.323155348926503 110.29934293708148 6.2358336537591175 111.83620008191168 6.2358336537591175 C 113.17125078204222 6.2358336537591175 114.12596506898221 6.131047939338876 115.56191437240912 6.131047939338876 C 115.56191437240912 6.131047939338876 118.97714299705038 6.034994634270841 118.97714299705038 6.034994634270841 L 118.97714299705038 13.965005365729159 C 118.97714299705038 13.965005365729159 115.56191437240912 13.868952060661124 115.56191437240912 13.868952060661124 C 114.12596506898221 13.868952060661124 113.17125078204222 13.764166346240883 111.83620008191168 13.764166346240883 C 110.29934293708148 13.764166346240883 110.16737800160932 13.676844651073498 108.7314286981824 13.676844651073498 C 107.39637799805185 13.676844651073498 106.75215399602153 13.580791346005462 105.31620007354115 13.580791346005462 C 103.88025077011422 13.580791346005462 103.84112828181617 13.484737627985723 101.90065362853323 13.484737627985723 C 100.46469970605285 13.484737627985723 100.06317582937044 13.215256585956926 97.10887819363285 13.340414571082576 C 95.1711911823335 13.442211117447117 93.034411927593 13.349776546813363 89.17178657046124 13.722738846572602 C 86.22925590294784 14.017325800153806 82.53878116717488 14.601608625887167 78.18638168717791 14.907190207504051 C 74.31369927095926 15.15178838017544 70.37423836234693 15.168419963640046 65.60884368640345 15.22941763919434 C 61.24567973113574 15.277478381487384 57.48733185461269 15.55072654682208 51.914285768094736 15.55072654682208 C 47.148474698482275 15.55072654682208 40.737146094408665 16.004797842734533 35.76952858009654 16.004797842734533 C 30.19648249357859 16.004797842734533 24.638964954094718 16.406476281436863 21.487628537346666 16.406476281436863 C 16.520011023034545 16.406476281436863 14.028428576596774 16.65097654823461 12.794285717869496 16.65097654823461 C 10.041524188936085 16.65097654823461 10.326000000448353 16.57238726241943 10.000000000029825 16.57238726241943 z" />
<circle cx="10.0" cy="12.173328598632807" r="4.399058663786621" />
<circle cx="118.97714299705038" cy="10.0" r="3.965005365729159" />
<path d="M 131.39620010691672 117.97453404627365 C 131.07020010649822 117.97453404627365 128.38457477838966 118.09678417967253 127.04952869731254 118.09678417967253 C 125.31086048872926 118.09678417967253 125.38072544853445 118.18410547511414 123.94477152605407 118.18410547511414 C 122.60972544497697 118.18410547511414 122.02949416601996 118.2786777530649 120.38899895950064 118.22390544801029 C 118.95496764291963 118.15269220752927 117.58577390810032 118.09126867559132 115.81609980372075 117.79873912346999 C 114.2090019688686 117.46961657891548 112.55042827860275 117.0102577844435 110.65192968776242 116.26482013715501 C 109.00672028539559 115.54965845463319 107.03732608501602 114.43808487361571 105.35756349063988 113.38974089962201 C 103.65622612042779 112.26336921262006 102.15346163549339 111.08862652777569 100.7872930456447 109.87841649794595 C 99.345837940186 108.52130847466377 98.13675602551915 107.10980167290914 97.26750140915891 106.09675231847613 C 96.10565691321742 104.68854101473941 95.82814302639582 104.39980829735994 95.09324556639453 103.35457525287589 C 94.34881444883987 102.2466311848064 93.86894882757632 101.68530327708838 93.23118465862059 100.53054845660789 C 92.65338508798227 99.39133895788252 92.18700324493697 98.82010261481788 91.61170267643195 96.9404276256086 C 91.28366566895669 95.66302002452285 90.67764750832609 93.12148126924396 90.4668728222941 91.1936341192073 C 90.31355060612192 89.23219636644828 90.41916244065048 87.49446691250876 90.41916244065048 85.7558033229789 C 90.41916244065048 83.81532405064252 90.33147590039265 82.92046923481273 90.38017142174301 81.27973028058354 C 90.45746179920584 79.54299495105003 90.49309357155727 77.62351115651838 90.77961244276797 76.3831685544671 C 91.31382603896105 74.84170113859177 92.45464815012357 72.80044733815407 93.38871083085837 71.81709307062417 C 94.37125322572506 71.01103136406638 95.83601869960076 69.88076063527814 97.88610589015467 69.13406996254761 C 99.18990994974696 68.73482855014049 102.56326733266052 68.19213745283503 103.99987810572915 67.85146683046202 C 106.123039349882 67.3291215911064 106.01954533742978 67.34380765278206 107.43415570819214 67.00800895148511 C 108.87678045841363 66.69471806193843 109.95078535315274 66.56161500673443 111.17514900700878 66.36775478581794 C 112.61482504185494 66.16440429708204 112.74576538922848 66.04821511820076 114.38017892548207 65.95265187911494 C 115.61896778866962 65.91116208057856 117.33176115383162 65.86136700683174 118.66680723490872 65.86136700683174 C 120.30456760208875 65.86136700683174 122.34578029806016 65.61518446178674 123.56261156912053 66.14968322417182 C 124.5861814099722 66.95380821697069 127.22893284138823 70.3438731656614 127.64404919834485 71.60467076082932 C 127.90843785940906 72.93534380042287 127.9472458610619 74.86113138099326 127.89423383845357 76.30040084333015 C 127.81672497557935 77.63296608761283 127.75115777480192 79.07115366285704 127.46992295962706 80.45303839312515 C 127.09069965871537 81.83994383945397 126.51777676061053 83.14604483055385 125.93375026695836 84.47750889667073 C 125.34198360265862 85.76014772911104 124.69151753075616 87.36574706033859 123.90942775220486 88.44046760137589 C 122.93722662663623 89.51163795082245 121.0255102454929 91.0953827116734 119.82437132695966 91.70891159878872 C 118.58262193477543 92.18266022743072 116.82948821540123 92.52585113460654 115.3059067768839 92.75395552375541 C 113.96143937210536 92.92006350726709 113.2817981458452 92.74124096750826 111.52898606431937 92.98799520596604 C 110.00929724836027 93.24105852970038 108.75728273074041 93.65180272110666 107.13478183577541 93.86496883208697 C 105.37288040252213 94.02451343573529 104.103088051978 93.85107726015892 102.66352299048215 93.89747722034167 C 101.02823878519534 93.98160368856996 100.60865101228043 94.15746131751406 99.37698016760775 94.23232865969689 C 97.93783947002507 94.2879873506088 97.74816597031473 94.27483396212209 96.31221204783435 94.27483396212209 C 96.31221204783435 94.27483396212209 92.8971429576943 94.33612208383076 92.8971429576943 94.33612208383076 L 92.89714296944219 85.24864950079137 C 92.89714296944219 85.24864950079137 96.31255955352884 85.30993762250004 96.31255955352884 85.30993762250004 C 97.74851347600922 85.30993762250004 97.39722217191894 85.40810161583715 98.83636286950163 85.35244292492524 C 100.0680337141743 85.27757558274241 100.74502151556716 85.15044950079637 102.38030572085397 85.06632303256808 C 103.81987078234982 85.01992307238532 104.21951693007048 85.25837602447109 105.98141836332377 85.09883142082278 C 107.60391925828877 84.88566530984247 108.76086813829616 84.3660112254293 110.28055695425526 84.11294790169497 C 112.03336903578109 83.86619366323718 112.61059741790709 83.89215266064912 113.95506482268563 83.72604467713744 C 115.47864626120295 83.49794028798857 114.40436522293999 84.00292299226558 115.64611461512422 83.52917436362358 C 116.84725353365745 82.91564547650827 115.55648559328839 84.14307441998552 116.52868671885702 83.07190407053896 C 117.31077649740831 81.99718352950167 117.01734049858885 82.10798726517008 117.60910716288859 80.82534843272977 C 118.19313365654077 79.49388436661289 118.17753964626932 80.02721004008983 118.55676294718101 78.64030459376102 C 118.83799776235588 77.2584198634929 118.6758861122484 77.29502171361196 118.75339497512263 75.96245646932928 C 118.80640699773096 74.52318700699239 119.26796827629558 75.77934524890934 119.00357961523136 74.44867220931579 C 118.58846325827474 73.18787461414787 121.00381570157808 75.11921330302596 119.98024586072641 74.3150883102271 C 118.76341458966604 73.78058954784201 120.30429621960391 74.60340452756718 118.66653585242388 74.60340452756718 C 117.33148977134678 74.60340452756718 116.11958153727501 74.4706298567476 114.88079267408746 74.51211965528398 C 113.24637913783387 74.6076828943698 113.93692719166074 74.51460916661325 112.49725115681458 74.71795965534915 C 111.27288750295854 74.91181987626564 110.850383531626 75.00632883861587 109.4077587814045 75.31961972816255 C 107.99314841064214 75.6554184294595 108.13471195379357 75.81667375507874 106.01155070964072 76.33901899443435 C 104.57493993657208 76.67968961680737 102.25198411331517 77.14097450195851 100.94818005372288 77.54021591436563 C 98.89809286316897 78.28690658709615 100.8395460721397 77.15590248346061 99.85700367727301 77.96196419001839 C 98.92294099653822 78.9453184575483 99.89557270277143 76.82202139433387 99.36135910657835 78.3634888102092 C 99.07484023536765 79.60383141226048 99.21711917335375 79.80259166726655 99.13982879589092 81.53932699680006 C 99.09113327454055 83.18006595102925 99.10083777698345 83.81608907659955 99.10083777698345 85.75656834893594 C 99.10083777698345 87.49523193846579 98.89980517916764 88.29255685790454 99.05312739533983 90.25399461066357 C 99.26390208137181 92.18184176070022 99.44311767897544 93.16502213618828 99.7711546864507 94.44242973727404 C 100.34645525495573 96.32210472648332 100.05770161058486 95.30167084329558 100.63550118122318 96.44088034202095 C 101.2732653501789 97.59563516250144 101.13375211467965 97.47653800666146 101.8781832322343 98.58448207473094 C 102.6130806922356 99.62971511921499 102.26779718402585 99.40169380942775 103.42964167996735 100.80990511316448 C 104.29889629632758 101.82295446759748 104.67793770548143 102.50161858463919 106.11939281094013 103.85872660792137 C 107.48556140078881 105.06893663775111 107.92015648349593 105.43054486175771 109.62149385370802 106.55691654875966 C 111.30125644808416 107.60526052275335 111.99620398046225 107.93430415768286 113.64141338282909 108.64946584020468 C 115.53991197366942 109.39490348749317 115.56348825149409 109.27022436135208 117.17058608634623 109.59934690590659 C 118.94026019072581 109.89187645802792 119.23602710174839 109.72393867259768 120.6700584183294 109.7951519130787 C 122.31055362484872 109.84992421813331 122.60972544492562 109.83495188597485 123.94477152600271 109.83495188597485 C 125.38072544848309 109.83495188597485 125.31086048867529 109.92227318141646 127.04952869725857 109.92227318141646 C 128.38457477833566 109.92227318141646 131.07020010671133 110.04452331481534 131.39620010712983 110.04452331481534 z" />
<circle cx="131.39620010702328" cy="114.00952868054449" r="3.965005365729159" />
<circle cx="92.89714296356824" cy="89.79238579231107" r="4.543736291519695" />
<path d="M 188.83428594393888 65.46183633247554 C 188.50828594352038 65.46183633247554 187.2663859174373 65.53661805920856 185.7295287726071 65.53661805920856 C 184.39448269153 65.53661805920856 183.8433859130452 65.43183234478832 182.0038144821121 65.43183234478832 C 180.46695733728188 65.43183234478832 179.1862430499237 65.30085020176301 177.3466716189906 65.30085020176301 C 175.50710018805748 65.30085020176301 174.25543191445948 65.12516063017804 172.81572441270282 65.1679948553285 C 170.9786099817363 65.2556793765017 171.43433524235775 65.11012539118444 170.14554986018848 65.38066894016953 C 168.76639285854387 65.78338136465915 170.01944834311382 65.27313400968208 168.7888907530638 66.0638805009397 C 167.74647566923497 66.86750412896842 168.37171609051387 66.30849190064643 167.59186641181583 67.43792127322524 C 166.9029016258207 68.7242849778456 167.03721945214028 65.70766791352597 167.35958505155716 66.85200152630259 C 168.14895033747027 67.86497820608056 165.2305556767329 63.788146484359785 167.0804190873854 64.30559268375863 C 168.28277386590307 64.66916722193034 170.39435676695757 65.53113475141258 171.91448411064414 66.03784418058116 C 173.7373268766035 66.6454580426427 173.96959257078365 66.7314584208159 175.82568867540687 67.46473462749906 C 177.30312758660486 68.08415867000063 178.91653199871706 69.00798619920427 180.74623183466147 69.9129886226914 C 182.52781399967157 70.8133682290625 183.64929275961734 71.61913476795236 185.45051112782588 72.5797863966243 C 187.2517294960344 73.54043802529625 188.3500973638751 74.09995947471515 190.17343094998088 75.12359468261883 C 191.9453934365777 76.13702560724568 193.33873050951973 77.03540988826045 194.93485278335248 78.0024863930688 C 196.72129018120964 79.0893957509001 197.36050629015295 79.51444908187416 198.9286255780122 80.42981220186294 C 200.54979332606808 81.35406330662897 201.40363967879122 81.74830613698988 202.78119163121647 82.4481227077323 C 204.41052583972672 83.2492988081924 205.09573618714032 83.34250328652197 206.23490189754102 83.92076179818012 C 207.59027503321377 84.66139548861888 208.0001881296676 84.90756944355525 209.083871153914 85.58487355227113 C 210.16755705537847 86.26218044791244 211.4574817977773 86.75336884738766 212.38068340819788 87.68069732310224 C 213.13259402299525 88.70136037088812 214.4816578022054 91.05485299427377 214.83174066959393 92.44114963888069 C 215.02664218926125 93.74164831582021 215.14234771803763 95.90653136629959 215.04478519840774 97.2569300072902 C 214.8756169749313 98.68154868187125 214.58873104227362 100.86959169963755 213.89979132961489 102.15517817195231 C 213.08343805392954 103.21926867177058 211.23567636681543 104.80287794124159 209.7057560362918 105.87069879504016 C 208.47754928061397 106.6896688276315 206.573550450857 107.78246630665983 205.3137833760723 108.50843651988819 C 203.68131993056002 109.41211418813654 203.51334164292328 109.19365565288815 202.1655835136951 109.97315033233228 C 200.93113280181888 110.74052832587014 200.49215950384976 111.12148712625567 199.2384611513722 111.94974809417477 C 197.9262086770291 112.78873792942333 197.16442636574476 113.26281340580684 195.80484455045087 113.99627247783235 C 194.4656704027819 114.67718594483073 193.3492750608198 115.10962004399114 192.0535892900741 115.6726215028512 C 190.63025063616547 116.27397680528955 190.01624728609318 116.58283489261835 188.71922913955405 117.05192775505438 C 187.38121429495388 117.50462138366875 186.56444492512858 117.77719322359847 185.253888707186 118.12044285091103 C 183.91219349830908 118.43988054723185 182.99810893460756 118.67901334271775 181.57348520932473 118.84817849152778 C 180.2230917683186 118.94573828291674 178.89095080859678 118.87266832168726 177.65680794986952 118.87266832168726 C 176.22085402738915 118.87266832168726 175.92577823169214 118.97137804082597 174.6874536994622 118.92069411800131 C 173.45670285961177 118.83432004720396 172.17635429980473 119.04217887809791 170.37210720653724 118.26605981565316 C 169.29644528069238 117.65866176597427 166.65825461891316 115.73491884434395 165.2185305783483 114.50249066730808 C 163.74253020215355 113.18217573676732 162.413447514513 111.83718686803495 161.413293556934 110.75151701951354 C 161.413293556934 110.75151701951354 158.92668017518739 107.74125732264204 158.92668017518739 107.74125732264204 L 165.96094873883524 102.27017149272783 C 165.96094873883524 102.27017149272783 167.82099255435426 104.84848323160254 167.82099255435426 104.84848323160254 C 168.82114651193325 105.93415308012395 169.37024083097197 106.60768032749395 170.8462412071667 107.92799525803471 C 172.28596524773158 109.16042343507058 172.68937414089592 109.76654240252509 173.76503606674078 110.37394045220398 C 175.56928316000827 111.15005951464873 173.80751016971158 110.25387498582663 175.038261009562 110.34024905662397 C 176.27658554179195 110.39093297944864 176.2215242724205 110.38827485293803 177.65747819490088 110.38827485293803 C 178.89162105362814 110.38827485293803 179.22089316866632 110.51032447448647 180.57128660967246 110.4127646830975 C 181.99591033495528 110.24359953428748 181.7587022454485 110.21805220649877 183.10039745432542 109.89861451017795 C 184.410953672268 109.55536488286539 184.50658494481584 109.55696608940023 185.844599789416 109.10427246078586 C 187.14161793595514 108.63517959834984 187.2964153275017 108.60110553846627 188.71975398141032 107.99975023602792 C 190.01543975215603 107.43674877716786 190.45981024759132 107.25226976926008 191.79898439526028 106.5713563022617 C 193.15856621055417 105.8378972302362 193.2626296625102 105.73115623067044 194.5748821368533 104.89216639542187 C 195.82858048933085 104.06390542750277 196.6228234051684 103.28945652859235 197.85727411704462 102.52207853505449 C 199.2050322462728 101.74258385561036 199.28615357661377 101.78572705696189 200.91861702212606 100.88204938871354 C 202.17838409691075 100.15607917548517 203.37080909399174 99.37112861717489 204.59901584966957 98.55215858458355 C 206.1289361801932 97.48433773078499 205.17719871640733 98.98511251022407 205.99355199209268 97.9210220104058 C 206.6824917047514 96.63543553809104 205.92130413830387 98.03434608219038 206.09047236178037 96.60972740760933 C 206.1880348814102 95.25932876661872 206.4984184102615 95.89554920367587 206.30351689059418 94.59505052673634 C 205.95343402320566 93.20875388212943 207.02265628982656 94.78759445455452 206.2707456750292 93.76693140676863 C 205.3475440646086 92.83960293105406 205.68364372674372 93.43529068951173 204.59995782527926 92.75798379387042 C 203.51627480103286 92.08067968515454 203.83667168834697 92.05795785467093 202.48129855267422 91.31732416423218 C 201.34213284227351 90.73906565257403 200.73385735328227 90.48639639635508 199.10452314477203 89.68522029589496 C 197.72697119234678 88.98540372515255 196.50588545826918 88.28109628432045 194.8847177102133 87.35684517955443 C 193.31659842235405 86.44148205956564 192.59255641496705 85.90348024214609 190.8061190171099 84.81657088431479 C 189.20999674327715 83.84949437950644 188.0252176108347 83.12032208364545 186.25325512423788 82.1068911590186 C 184.4299215381321 81.08325595111492 183.4631075883578 80.64372254470709 181.66188922014928 79.68307091603513 C 179.86067085194074 78.7224192873632 178.8334649520801 78.28261976736111 177.05188278707 77.38224016099001 C 175.2221829511256 76.47723773750288 174.13557913127906 76.10326100141835 172.65814022008107 75.48383695891677 C 170.80204411545785 74.75056075223361 170.9407589698082 75.0345412158793 169.11791620384884 74.42692735381776 C 167.59778886016227 73.92021792464918 165.84005027938164 73.4179820050827 164.63769550086397 73.054407466911 C 162.78783209021148 72.53696126751215 159.55932338685912 70.27906106566446 158.769958100946 69.2660843858865 C 158.44759250152913 68.12175077310988 159.711569099941 63.75701400106985 160.4005338859361 62.47065029644949 C 161.18038356463416 61.34122092387068 163.12869456489304 59.680686167785744 164.17110964872188 58.87706253975703 C 165.4016672387719 58.086316048499405 167.02386497569879 57.47918647299994 168.4030219773434 57.07647404851032 C 169.69180735951267 56.805930499525246 170.72621866808927 56.75588974775638 172.5633330990558 56.668205226583176 C 174.00304060081245 56.62537100143272 175.5071001880785 56.53534988014867 177.34667161901163 56.53534988014867 C 179.18624304994472 56.53534988014867 180.46695733730354 56.404367737123366 182.00381448213375 56.404367737123366 C 183.84338591306687 56.404367737123366 184.39448269155653 56.29958202270313 185.72952877263364 56.29958202270313 C 187.26638591746385 56.29958202270313 188.5082859433977 56.37436374943615 188.8342859438162 56.37436374943615 z" />
<circle cx="188.83428594387755" cy="60.91810004095584" r="4.543736291519695" />
<circle cx="162.4438144570113" cy="105.00571440768493" r="4.455718639675663" />
<path d="M 266.25191891410964 11.552385692104027 C 266.25191891410964 11.878385692522555 266.36778253677335 14.703714291753027 266.36778253677335 17.451428580994897 C 266.36778253677335 19.694617520380756 266.15821110793286 21.751525364295183 266.15821110793286 24.902857161989793 C 266.15821110793286 27.650571451231666 265.9137112408609 30.14213506614217 265.9137112408609 33.59618576899314 C 265.9137112408609 36.74751756668775 265.6430145454581 39.766911077295426 265.6430145454581 43.220957161092954 C 265.6430145454581 46.675007863943925 265.3723182497811 49.49257147927297 265.3723182497811 52.84571434072066 C 265.3723182497811 56.29976042451819 265.2458862110673 58.806857205516586 265.2458862110673 62.16000006696429 C 265.2458862110673 65.51314292841198 265.25171640514475 68.52476044021294 265.25171640514475 71.47428579320791 C 265.25171640514475 74.8274286546556 265.36059690177996 77.10167149030413 265.36059690177996 79.54667149344309 C 265.36059690177996 82.49619684643804 265.53225590350536 83.9243857847776 265.53225590350536 86.06667150181363 C 265.53225590350536 88.51167150495257 265.64241796173656 89.91657934802994 265.64241796173656 91.65524293755979 C 265.64241796173656 93.79752865459582 265.7646676954096 94.66684943469485 265.7646676954096 96.0019001348254 C 265.7646676954096 97.74056372435527 265.85198939057705 97.77162543747758 265.85198939057705 99.10667151855469 C 265.85198939057705 99.10667151855469 265.93931068601864 102.21142868981185 265.93931068601864 102.21142868981185 L 257.65308986284936 102.21142868981185 C 257.65308986284936 102.21142868981185 257.74041115829095 99.10667151855469 257.74041115829095 99.10667151855469 C 257.74041115829095 97.77162543747758 257.8277328534584 97.74056372435527 257.8277328534584 96.0019001348254 C 257.8277328534584 94.66684943469485 257.94998258713144 93.79752865459582 257.94998258713144 91.65524293755979 C 257.94998258713144 89.91657934802994 258.06014464536264 88.51167150495257 258.06014464536264 86.06667150181363 C 258.06014464536264 83.9243857847776 258.23180364708804 82.49619684643804 258.23180364708804 79.54667149344309 C 258.23180364708804 77.10167149030413 258.34068414372325 74.8274286546556 258.34068414372325 71.47428579320791 C 258.34068414372325 68.52476044021294 258.3465143378007 65.51314292841198 258.3465143378007 62.16000006696429 C 258.3465143378007 58.806857205516586 258.2200822990869 56.29976042451819 258.2200822990869 52.84571434072066 C 258.2200822990869 49.49257147927297 257.9493860034099 46.675007863943925 257.9493860034099 43.220957161092954 C 257.9493860034099 39.766911077295426 257.6786893080071 36.74751756668775 257.6786893080071 33.59618576899314 C 257.6786893080071 30.14213506614217 257.43418944093514 27.650571451231666 257.43418944093514 24.902857161989793 C 257.43418944093514 21.751525364295183 257.22461801209465 19.694617520380756 257.22461801209465 17.451428580994897 C 257.22461801209465 14.703714291753027 257.34048163475836 11.87838569204379 257.34048163475836 11.552385691625261 z" />
<circle cx="261.796200274434" cy="11.552385691864643" r="4.455718639675663" />
<circle cx="261.796200274434" cy="102.21142868981185" r="4.143110411584649" />
<path d="M 249.44353436234087 35.98027212095298 C 249.76897182352252 35.96112899862347 252.4877865456646 35.58969457284138 254.830584142954 35.516029013063715 C 256.8742999293939 35.46960495133038 258.6294149577224 35.688544142828086 261.1753181832112 35.688544142828086 C 263.5194149640003 35.688544142828086 265.66161783615917 35.88065115200631 268.00571461694835 35.88065115200631 C 270.5516178424371 35.88065115200631 272.5774828047548 35.95010335834191 274.2152431719348 35.95010335834191 C 276.5593399527239 35.95010335834191 276.81547499333595 35.83658563429524 278.2514289158163 35.83658563429524 C 278.2514289158163 35.83658563429524 281.6666717529297 35.74053192950143 281.6666717529297 35.74053192950143 L 281.6666717529297 43.87089671845774 C 281.6666717529297 43.87089671845774 278.2514289158163 43.77484301366393 278.2514289158163 43.77484301366393 C 276.81547499333595 43.77484301366393 276.5593399527239 43.66132528961726 274.2152431719348 43.66132528961726 C 272.5774828047548 43.66132528961726 270.5516178424371 43.730777495952864 268.00571461694835 43.730777495952864 C 265.66161783615917 43.730777495952864 263.51926490796535 43.92288450513109 261.1751681271762 43.92288450513109 C 258.62926490168746 43.92288450513109 257.1445608439005 44.04897557316211 255.10084505746053 44.09539963489546 C 252.75804746017113 44.169065194673124 250.25716075947537 44.232956311444845 249.93172329829372 44.252099433774355 z" />
<circle cx="249.6876288303173" cy="40.11618577736367" r="4.143110411584649" />
<circle cx="281.6666717529297" cy="39.805714323979586" r="4.065182394478157" />
</g>
</svg>
""";
  final signature = Attachment(
    name: 'signature',
    url: Uri.parse('https://test.de'),
    type: 'image/svg+xml',
  );
  final formData = FormData(
    id: 'formId',
    title: 'title',
    components: [
      FormComponent<SignatureDataEntity>(
        property: 'Property',
        data: SignatureDataEntity(),
        field: field,
        required: true,
      ),
    ],
    links: {ApptiveLinkType.submit: action},
    fields: [field],
  );
  final formDataPrefilled = FormData(
    id: 'formId',
    title: 'title',
    components: [
      FormComponent<SignatureDataEntity>(
        property: 'Property',
        data: SignatureDataEntity(signature),
        field: field,
        required: true,
      ),
    ],
    links: {ApptiveLinkType.submit: action},
    fields: [field],
  );
  final httpClient = MockHttpClient();
  final client = MockApptiveGridClient();

  setUpAll(() {
    registerFallbackValue(
      FormData(
        id: 'id',
        links: {},
        title: 'title',
        components: [],
        fields: [],
      ),
    );
    when(() => client.sendPendingActions()).thenAnswer((_) => Future.value([]));
    when(() => client.submitFormWithProgress(action, any())).thenAnswer(
      (_) =>
          Stream.value(SubmitCompleteProgressEvent(http.Response('body', 200))),
    );
    when(() => client.httpClient).thenReturn(httpClient);
  });

  // The checks if the UI shows the signature icon on an empty signature
  void checkSignature({required bool isEmpty}) => expect(
        find.descendant(
          of: find.byType(SignatureFormWidget),
          matching: find.byType(Icon),
        ),
        isEmpty ? findsOneWidget : findsNothing,
      );

  group('Validation', () {
    testWidgets('is required', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsOneWidget,
      );
    });
    testWidgets('is required but filled sends', (tester) async {
      when(() => httpClient.get(signature.url))
          .thenAnswer((invocation) async => http.Response(svgString, 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formDataPrefilled,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Property must not be empty', skipOffstage: true),
        findsNothing,
      );
    });
  });
  group('add signature', () {
    final attachmentProcessor = MockAttachmentProcessor();
    when(() => client.attachmentProcessor).thenReturn(attachmentProcessor);
    when(() => attachmentProcessor.createAttachment(any())).thenAnswer(
      (invocation) async {
        final name = invocation.positionalArguments.first;
        return Attachment(
          name: name,
          type: 'image/svg+xml',
          url: Uri.parse(
            '$name.com',
          ),
        );
      },
    );

    testWidgets('add new signature', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SignatureFormWidget));
      await tester.pumpAndSettle();

      final sigantureField = tester.getRect(find.byType(HandSignature));

      await tester.dragFrom(
        sigantureField.centerLeft,
        sigantureField.centerRight,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        ),
      );
      await tester.pumpAndSettle();

      checkSignature(isEmpty: false);

      verify(
        () => attachmentProcessor.createAttachment(any()),
      ).called(1);
    });

    testWidgets('new signature overrides old signature', (tester) async {
      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formData,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SignatureFormWidget));
      await tester.pumpAndSettle();

      var sigantureField = tester.getRect(find.byType(HandSignature));

      await tester.dragFrom(
        sigantureField.centerLeft,
        sigantureField.centerRight,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SignatureFormWidget));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      sigantureField = tester.getRect(find.byType(HandSignature));

      await tester.dragFrom(
        sigantureField.centerLeft,
        sigantureField.centerRight,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        ),
      );
      await tester.pumpAndSettle();

      checkSignature(isEmpty: false);

      verify(
        () => attachmentProcessor.createAttachment(any()),
      ).called(2);
    });
  });
  group('clear signature', () {
    testWidgets('clear filled signature', (tester) async {
      when(() => httpClient.get(signature.url))
          .thenAnswer((invocation) async => http.Response(svgString, 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formDataPrefilled,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SignatureFormWidget));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        ),
      );
      await tester.pumpAndSettle();

      checkSignature(isEmpty: true);
    });

    testWidgets('do not clear filled signature on cancel', (tester) async {
      when(() => httpClient.get(signature.url))
          .thenAnswer((invocation) async => http.Response(svgString, 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formDataPrefilled,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SignatureFormWidget));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ModalBarrier).first);
      await tester.pumpAndSettle();

      checkSignature(isEmpty: false);
    });
  });
  group('load prefilled signature', () {
    testWidgets('load prefilled', (tester) async {
      when(() => httpClient.get(signature.url))
          .thenAnswer((invocation) async => http.Response(svgString, 200));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formDataPrefilled,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      checkSignature(isEmpty: false);
    });

    testWidgets('load prefilled error show empty', (tester) async {
      when(() => httpClient.get(signature.url))
          .thenAnswer((invocation) async => http.Response('error', 400));

      final target = TestApp(
        client: client,
        child: ApptiveGridFormData(
          formData: formDataPrefilled,
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      checkSignature(isEmpty: true);
    });
  });
}
