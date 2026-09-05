/// Countries selectable in an [AddressFormWidget], with their ISO 3166-1
/// alpha-2 code and display names in English and German.
///
/// Generated from active-grid-web `src/constants/countries/world.js` and
/// `world_de.js` (https://github.com/stefangabos/world_countries), joined on
/// the alpha-2 code and sorted by the English name.
library;

/// A country with its ISO code and localized names
class Country {
  /// Creates a [Country]
  const Country({
    required this.alpha2,
    required this.nameEn,
    required this.nameDe,
  });

  /// ISO 3166-1 alpha-2 code, lower case (e.g. `de`)
  final String alpha2;

  /// English display name
  final String nameEn;

  /// German display name
  final String nameDe;

  /// The display name for [languageCode], falling back to English
  String name(String? languageCode) => languageCode == 'de' ? nameDe : nameEn;

  @override
  String toString() => 'Country($alpha2, $nameEn, $nameDe)';
}

/// Finds the country whose English or German name equals [name]
/// (case-insensitive). Returns `null` if there is no match.
Country? countryByName(String? name) {
  if (name == null || name.trim().isEmpty) {
    return null;
  }
  final query = name.trim().toLowerCase();
  for (final country in kCountries) {
    if (country.nameEn.toLowerCase() == query ||
        country.nameDe.toLowerCase() == query) {
      return country;
    }
  }
  return null;
}

/// All countries, sorted by English name
const List<Country> kCountries = [
  Country(
    alpha2: 'af',
    nameEn: 'Afghanistan',
    nameDe: 'Afghanistan',
  ),
  Country(
    alpha2: 'al',
    nameEn: 'Albania',
    nameDe: 'Albanien',
  ),
  Country(
    alpha2: 'dz',
    nameEn: 'Algeria',
    nameDe: 'Algerien',
  ),
  Country(
    alpha2: 'as',
    nameEn: 'American Samoa',
    nameDe: 'Amerikanisch-Samoa',
  ),
  Country(
    alpha2: 'ad',
    nameEn: 'Andorra',
    nameDe: 'Andorra',
  ),
  Country(
    alpha2: 'ao',
    nameEn: 'Angola',
    nameDe: 'Angola',
  ),
  Country(
    alpha2: 'ai',
    nameEn: 'Anguilla',
    nameDe: 'Anguilla',
  ),
  Country(
    alpha2: 'aq',
    nameEn: 'Antarctica',
    nameDe: 'Antarktis (Sonderstatus durch Antarktisvertrag)',
  ),
  Country(
    alpha2: 'ag',
    nameEn: 'Antigua and Barbuda',
    nameDe: 'Antigua und Barbuda',
  ),
  Country(
    alpha2: 'ar',
    nameEn: 'Argentina',
    nameDe: 'Argentinien',
  ),
  Country(
    alpha2: 'am',
    nameEn: 'Armenia',
    nameDe: 'Armenien',
  ),
  Country(
    alpha2: 'aw',
    nameEn: 'Aruba',
    nameDe: 'Aruba',
  ),
  Country(
    alpha2: 'au',
    nameEn: 'Australia',
    nameDe: 'Australien',
  ),
  Country(
    alpha2: 'at',
    nameEn: 'Austria',
    nameDe: 'Österreich',
  ),
  Country(
    alpha2: 'az',
    nameEn: 'Azerbaijan',
    nameDe: 'Aserbaidschan',
  ),
  Country(
    alpha2: 'bs',
    nameEn: 'Bahamas',
    nameDe: 'Bahamas',
  ),
  Country(
    alpha2: 'bh',
    nameEn: 'Bahrain',
    nameDe: 'Bahrain',
  ),
  Country(
    alpha2: 'bd',
    nameEn: 'Bangladesh',
    nameDe: 'Bangladesch',
  ),
  Country(
    alpha2: 'bb',
    nameEn: 'Barbados',
    nameDe: 'Barbados',
  ),
  Country(
    alpha2: 'by',
    nameEn: 'Belarus',
    nameDe: 'Belarus',
  ),
  Country(
    alpha2: 'be',
    nameEn: 'Belgium',
    nameDe: 'Belgien',
  ),
  Country(
    alpha2: 'bz',
    nameEn: 'Belize',
    nameDe: 'Belize',
  ),
  Country(
    alpha2: 'bj',
    nameEn: 'Benin',
    nameDe: 'Benin',
  ),
  Country(
    alpha2: 'bm',
    nameEn: 'Bermuda',
    nameDe: 'Bermuda',
  ),
  Country(
    alpha2: 'bt',
    nameEn: 'Bhutan',
    nameDe: 'Bhutan',
  ),
  Country(
    alpha2: 'bo',
    nameEn: 'Bolivia (Plurinational State of)',
    nameDe: 'Bolivien',
  ),
  Country(
    alpha2: 'bq',
    nameEn: 'Bonaire, Sint Eustatius and Saba',
    nameDe: 'Bonaire, Saba, Sint Eustatius',
  ),
  Country(
    alpha2: 'ba',
    nameEn: 'Bosnia and Herzegovina',
    nameDe: 'Bosnien und Herzegowina',
  ),
  Country(
    alpha2: 'bw',
    nameEn: 'Botswana',
    nameDe: 'Botswana',
  ),
  Country(
    alpha2: 'bv',
    nameEn: 'Bouvet Island',
    nameDe: 'Bouvetinsel',
  ),
  Country(
    alpha2: 'br',
    nameEn: 'Brazil',
    nameDe: 'Brasilien',
  ),
  Country(
    alpha2: 'io',
    nameEn: 'British Indian Ocean Territory',
    nameDe: 'Britisches Territorium im Indischen Ozean',
  ),
  Country(
    alpha2: 'bn',
    nameEn: 'Brunei Darussalam',
    nameDe: 'Brunei',
  ),
  Country(
    alpha2: 'bg',
    nameEn: 'Bulgaria',
    nameDe: 'Bulgarien',
  ),
  Country(
    alpha2: 'bf',
    nameEn: 'Burkina Faso',
    nameDe: 'Burkina Faso',
  ),
  Country(
    alpha2: 'bi',
    nameEn: 'Burundi',
    nameDe: 'Burundi',
  ),
  Country(
    alpha2: 'cv',
    nameEn: 'Cabo Verde',
    nameDe: 'Kap Verde',
  ),
  Country(
    alpha2: 'kh',
    nameEn: 'Cambodia',
    nameDe: 'Kambodscha',
  ),
  Country(
    alpha2: 'cm',
    nameEn: 'Cameroon',
    nameDe: 'Kamerun',
  ),
  Country(
    alpha2: 'ca',
    nameEn: 'Canada',
    nameDe: 'Kanada',
  ),
  Country(
    alpha2: 'ky',
    nameEn: 'Cayman Islands',
    nameDe: 'Kaimaninseln',
  ),
  Country(
    alpha2: 'cf',
    nameEn: 'Central African Republic',
    nameDe: 'Zentralafrikanische Republik',
  ),
  Country(
    alpha2: 'td',
    nameEn: 'Chad',
    nameDe: 'Tschad',
  ),
  Country(
    alpha2: 'cl',
    nameEn: 'Chile',
    nameDe: 'Chile',
  ),
  Country(
    alpha2: 'cn',
    nameEn: 'China',
    nameDe: 'China, Volksrepublik',
  ),
  Country(
    alpha2: 'cx',
    nameEn: 'Christmas Island',
    nameDe: 'Weihnachtsinsel',
  ),
  Country(
    alpha2: 'cc',
    nameEn: 'Cocos (Keeling) Islands',
    nameDe: 'Kokosinseln',
  ),
  Country(
    alpha2: 'co',
    nameEn: 'Colombia',
    nameDe: 'Kolumbien',
  ),
  Country(
    alpha2: 'km',
    nameEn: 'Comoros',
    nameDe: 'Komoren',
  ),
  Country(
    alpha2: 'cg',
    nameEn: 'Congo',
    nameDe: 'Kongo, Republik',
  ),
  Country(
    alpha2: 'cd',
    nameEn: 'Congo, Democratic Republic of the',
    nameDe: 'Kongo, Demokratische Republik',
  ),
  Country(
    alpha2: 'ck',
    nameEn: 'Cook Islands',
    nameDe: 'Cookinseln',
  ),
  Country(
    alpha2: 'cr',
    nameEn: 'Costa Rica',
    nameDe: 'Costa Rica',
  ),
  Country(
    alpha2: 'hr',
    nameEn: 'Croatia',
    nameDe: 'Kroatien',
  ),
  Country(
    alpha2: 'cu',
    nameEn: 'Cuba',
    nameDe: 'Kuba',
  ),
  Country(
    alpha2: 'cw',
    nameEn: 'Curaçao',
    nameDe: 'Curaçao',
  ),
  Country(
    alpha2: 'cy',
    nameEn: 'Cyprus',
    nameDe: 'Zypern',
  ),
  Country(
    alpha2: 'cz',
    nameEn: 'Czechia',
    nameDe: 'Tschechien',
  ),
  Country(
    alpha2: 'ci',
    nameEn: 'Côte d\'Ivoire',
    nameDe: 'Elfenbeinküste',
  ),
  Country(
    alpha2: 'dk',
    nameEn: 'Denmark',
    nameDe: 'Dänemark',
  ),
  Country(
    alpha2: 'dj',
    nameEn: 'Djibouti',
    nameDe: 'Dschibuti',
  ),
  Country(
    alpha2: 'dm',
    nameEn: 'Dominica',
    nameDe: 'Dominica',
  ),
  Country(
    alpha2: 'do',
    nameEn: 'Dominican Republic',
    nameDe: 'Dominikanische Republik',
  ),
  Country(
    alpha2: 'ec',
    nameEn: 'Ecuador',
    nameDe: 'Ecuador',
  ),
  Country(
    alpha2: 'eg',
    nameEn: 'Egypt',
    nameDe: 'Ägypten',
  ),
  Country(
    alpha2: 'sv',
    nameEn: 'El Salvador',
    nameDe: 'El Salvador',
  ),
  Country(
    alpha2: 'gq',
    nameEn: 'Equatorial Guinea',
    nameDe: 'Äquatorialguinea',
  ),
  Country(
    alpha2: 'er',
    nameEn: 'Eritrea',
    nameDe: 'Eritrea',
  ),
  Country(
    alpha2: 'ee',
    nameEn: 'Estonia',
    nameDe: 'Estland',
  ),
  Country(
    alpha2: 'sz',
    nameEn: 'Eswatini',
    nameDe: 'Eswatini',
  ),
  Country(
    alpha2: 'et',
    nameEn: 'Ethiopia',
    nameDe: 'Äthiopien',
  ),
  Country(
    alpha2: 'fk',
    nameEn: 'Falkland Islands (Malvinas)',
    nameDe: 'Falklandinseln',
  ),
  Country(
    alpha2: 'fo',
    nameEn: 'Faroe Islands',
    nameDe: 'Färöer',
  ),
  Country(
    alpha2: 'fj',
    nameEn: 'Fiji',
    nameDe: 'Fidschi',
  ),
  Country(
    alpha2: 'fi',
    nameEn: 'Finland',
    nameDe: 'Finnland',
  ),
  Country(
    alpha2: 'fr',
    nameEn: 'France',
    nameDe: 'Frankreich',
  ),
  Country(
    alpha2: 'gf',
    nameEn: 'French Guiana',
    nameDe: 'Französisch-Guayana',
  ),
  Country(
    alpha2: 'pf',
    nameEn: 'French Polynesia',
    nameDe: 'Französisch-Polynesien',
  ),
  Country(
    alpha2: 'tf',
    nameEn: 'French Southern Territories',
    nameDe: 'Französische Süd- und Antarktisgebiete',
  ),
  Country(
    alpha2: 'ga',
    nameEn: 'Gabon',
    nameDe: 'Gabun',
  ),
  Country(
    alpha2: 'gm',
    nameEn: 'Gambia',
    nameDe: 'Gambia',
  ),
  Country(
    alpha2: 'ge',
    nameEn: 'Georgia',
    nameDe: 'Georgien',
  ),
  Country(
    alpha2: 'de',
    nameEn: 'Germany',
    nameDe: 'Deutschland',
  ),
  Country(
    alpha2: 'gh',
    nameEn: 'Ghana',
    nameDe: 'Ghana',
  ),
  Country(
    alpha2: 'gi',
    nameEn: 'Gibraltar',
    nameDe: 'Gibraltar',
  ),
  Country(
    alpha2: 'gr',
    nameEn: 'Greece',
    nameDe: 'Griechenland',
  ),
  Country(
    alpha2: 'gl',
    nameEn: 'Greenland',
    nameDe: 'Grönland',
  ),
  Country(
    alpha2: 'gd',
    nameEn: 'Grenada',
    nameDe: 'Grenada',
  ),
  Country(
    alpha2: 'gp',
    nameEn: 'Guadeloupe',
    nameDe: 'Guadeloupe',
  ),
  Country(
    alpha2: 'gu',
    nameEn: 'Guam',
    nameDe: 'Guam',
  ),
  Country(
    alpha2: 'gt',
    nameEn: 'Guatemala',
    nameDe: 'Guatemala',
  ),
  Country(
    alpha2: 'gg',
    nameEn: 'Guernsey',
    nameDe: 'Guernsey (Kanalinsel)',
  ),
  Country(
    alpha2: 'gn',
    nameEn: 'Guinea',
    nameDe: 'Guinea',
  ),
  Country(
    alpha2: 'gw',
    nameEn: 'Guinea-Bissau',
    nameDe: 'Guinea-Bissau',
  ),
  Country(
    alpha2: 'gy',
    nameEn: 'Guyana',
    nameDe: 'Guyana',
  ),
  Country(
    alpha2: 'ht',
    nameEn: 'Haiti',
    nameDe: 'Haiti',
  ),
  Country(
    alpha2: 'hm',
    nameEn: 'Heard Island and McDonald Islands',
    nameDe: 'Heard und McDonaldinseln',
  ),
  Country(
    alpha2: 'va',
    nameEn: 'Holy See',
    nameDe: 'Vatikanstadt',
  ),
  Country(
    alpha2: 'hn',
    nameEn: 'Honduras',
    nameDe: 'Honduras',
  ),
  Country(
    alpha2: 'hk',
    nameEn: 'Hong Kong',
    nameDe: 'Hongkong',
  ),
  Country(
    alpha2: 'hu',
    nameEn: 'Hungary',
    nameDe: 'Ungarn',
  ),
  Country(
    alpha2: 'is',
    nameEn: 'Iceland',
    nameDe: 'Island',
  ),
  Country(
    alpha2: 'in',
    nameEn: 'India',
    nameDe: 'Indien',
  ),
  Country(
    alpha2: 'id',
    nameEn: 'Indonesia',
    nameDe: 'Indonesien',
  ),
  Country(
    alpha2: 'ir',
    nameEn: 'Iran (Islamic Republic of)',
    nameDe: 'Iran',
  ),
  Country(
    alpha2: 'iq',
    nameEn: 'Iraq',
    nameDe: 'Irak',
  ),
  Country(
    alpha2: 'ie',
    nameEn: 'Ireland',
    nameDe: 'Irland',
  ),
  Country(
    alpha2: 'im',
    nameEn: 'Isle of Man',
    nameDe: 'Insel Man',
  ),
  Country(
    alpha2: 'il',
    nameEn: 'Israel',
    nameDe: 'Israel',
  ),
  Country(
    alpha2: 'it',
    nameEn: 'Italy',
    nameDe: 'Italien',
  ),
  Country(
    alpha2: 'jm',
    nameEn: 'Jamaica',
    nameDe: 'Jamaika',
  ),
  Country(
    alpha2: 'jp',
    nameEn: 'Japan',
    nameDe: 'Japan',
  ),
  Country(
    alpha2: 'je',
    nameEn: 'Jersey',
    nameDe: 'Jersey (Kanalinsel)',
  ),
  Country(
    alpha2: 'jo',
    nameEn: 'Jordan',
    nameDe: 'Jordanien',
  ),
  Country(
    alpha2: 'kz',
    nameEn: 'Kazakhstan',
    nameDe: 'Kasachstan',
  ),
  Country(
    alpha2: 'ke',
    nameEn: 'Kenya',
    nameDe: 'Kenia',
  ),
  Country(
    alpha2: 'ki',
    nameEn: 'Kiribati',
    nameDe: 'Kiribati',
  ),
  Country(
    alpha2: 'kp',
    nameEn: 'Korea (Democratic People\'s Republic of)',
    nameDe: 'Korea, Nord (Nordkorea)',
  ),
  Country(
    alpha2: 'kr',
    nameEn: 'Korea, Republic of',
    nameDe: 'Korea, Süd (Südkorea)',
  ),
  Country(
    alpha2: 'kw',
    nameEn: 'Kuwait',
    nameDe: 'Kuwait',
  ),
  Country(
    alpha2: 'kg',
    nameEn: 'Kyrgyzstan',
    nameDe: 'Kirgisistan',
  ),
  Country(
    alpha2: 'la',
    nameEn: 'Lao People\'s Democratic Republic',
    nameDe: 'Laos',
  ),
  Country(
    alpha2: 'lv',
    nameEn: 'Latvia',
    nameDe: 'Lettland',
  ),
  Country(
    alpha2: 'lb',
    nameEn: 'Lebanon',
    nameDe: 'Libanon',
  ),
  Country(
    alpha2: 'ls',
    nameEn: 'Lesotho',
    nameDe: 'Lesotho',
  ),
  Country(
    alpha2: 'lr',
    nameEn: 'Liberia',
    nameDe: 'Liberia',
  ),
  Country(
    alpha2: 'ly',
    nameEn: 'Libya',
    nameDe: 'Libyen',
  ),
  Country(
    alpha2: 'li',
    nameEn: 'Liechtenstein',
    nameDe: 'Liechtenstein',
  ),
  Country(
    alpha2: 'lt',
    nameEn: 'Lithuania',
    nameDe: 'Litauen',
  ),
  Country(
    alpha2: 'lu',
    nameEn: 'Luxembourg',
    nameDe: 'Luxemburg',
  ),
  Country(
    alpha2: 'mo',
    nameEn: 'Macao',
    nameDe: 'Macau',
  ),
  Country(
    alpha2: 'mg',
    nameEn: 'Madagascar',
    nameDe: 'Madagaskar',
  ),
  Country(
    alpha2: 'mw',
    nameEn: 'Malawi',
    nameDe: 'Malawi',
  ),
  Country(
    alpha2: 'my',
    nameEn: 'Malaysia',
    nameDe: 'Malaysia',
  ),
  Country(
    alpha2: 'mv',
    nameEn: 'Maldives',
    nameDe: 'Malediven',
  ),
  Country(
    alpha2: 'ml',
    nameEn: 'Mali',
    nameDe: 'Mali',
  ),
  Country(
    alpha2: 'mt',
    nameEn: 'Malta',
    nameDe: 'Malta',
  ),
  Country(
    alpha2: 'mh',
    nameEn: 'Marshall Islands',
    nameDe: 'Marshallinseln',
  ),
  Country(
    alpha2: 'mq',
    nameEn: 'Martinique',
    nameDe: 'Martinique',
  ),
  Country(
    alpha2: 'mr',
    nameEn: 'Mauritania',
    nameDe: 'Mauretanien',
  ),
  Country(
    alpha2: 'mu',
    nameEn: 'Mauritius',
    nameDe: 'Mauritius',
  ),
  Country(
    alpha2: 'yt',
    nameEn: 'Mayotte',
    nameDe: 'Mayotte',
  ),
  Country(
    alpha2: 'mx',
    nameEn: 'Mexico',
    nameDe: 'Mexiko',
  ),
  Country(
    alpha2: 'fm',
    nameEn: 'Micronesia (Federated States of)',
    nameDe: 'Mikronesien',
  ),
  Country(
    alpha2: 'md',
    nameEn: 'Moldova, Republic of',
    nameDe: 'Moldau',
  ),
  Country(
    alpha2: 'mc',
    nameEn: 'Monaco',
    nameDe: 'Monaco',
  ),
  Country(
    alpha2: 'mn',
    nameEn: 'Mongolia',
    nameDe: 'Mongolei',
  ),
  Country(
    alpha2: 'me',
    nameEn: 'Montenegro',
    nameDe: 'Montenegro',
  ),
  Country(
    alpha2: 'ms',
    nameEn: 'Montserrat',
    nameDe: 'Montserrat',
  ),
  Country(
    alpha2: 'ma',
    nameEn: 'Morocco',
    nameDe: 'Marokko',
  ),
  Country(
    alpha2: 'mz',
    nameEn: 'Mozambique',
    nameDe: 'Mosambik',
  ),
  Country(
    alpha2: 'mm',
    nameEn: 'Myanmar',
    nameDe: 'Myanmar',
  ),
  Country(
    alpha2: 'na',
    nameEn: 'Namibia',
    nameDe: 'Namibia',
  ),
  Country(
    alpha2: 'nr',
    nameEn: 'Nauru',
    nameDe: 'Nauru',
  ),
  Country(
    alpha2: 'np',
    nameEn: 'Nepal',
    nameDe: 'Nepal',
  ),
  Country(
    alpha2: 'nl',
    nameEn: 'Netherlands',
    nameDe: 'Niederlande',
  ),
  Country(
    alpha2: 'nc',
    nameEn: 'New Caledonia',
    nameDe: 'Neukaledonien',
  ),
  Country(
    alpha2: 'nz',
    nameEn: 'New Zealand',
    nameDe: 'Neuseeland',
  ),
  Country(
    alpha2: 'ni',
    nameEn: 'Nicaragua',
    nameDe: 'Nicaragua',
  ),
  Country(
    alpha2: 'ne',
    nameEn: 'Niger',
    nameDe: 'Niger',
  ),
  Country(
    alpha2: 'ng',
    nameEn: 'Nigeria',
    nameDe: 'Nigeria',
  ),
  Country(
    alpha2: 'nu',
    nameEn: 'Niue',
    nameDe: 'Niue',
  ),
  Country(
    alpha2: 'nf',
    nameEn: 'Norfolk Island',
    nameDe: 'Norfolkinsel',
  ),
  Country(
    alpha2: 'mk',
    nameEn: 'North Macedonia',
    nameDe: 'Nordmazedonien',
  ),
  Country(
    alpha2: 'mp',
    nameEn: 'Northern Mariana Islands',
    nameDe: 'Nördliche Marianen',
  ),
  Country(
    alpha2: 'no',
    nameEn: 'Norway',
    nameDe: 'Norwegen',
  ),
  Country(
    alpha2: 'om',
    nameEn: 'Oman',
    nameDe: 'Oman',
  ),
  Country(
    alpha2: 'pk',
    nameEn: 'Pakistan',
    nameDe: 'Pakistan',
  ),
  Country(
    alpha2: 'pw',
    nameEn: 'Palau',
    nameDe: 'Palau',
  ),
  Country(
    alpha2: 'ps',
    nameEn: 'Palestine, State of',
    nameDe: 'Palästina',
  ),
  Country(
    alpha2: 'pa',
    nameEn: 'Panama',
    nameDe: 'Panama',
  ),
  Country(
    alpha2: 'pg',
    nameEn: 'Papua New Guinea',
    nameDe: 'Papua-Neuguinea',
  ),
  Country(
    alpha2: 'py',
    nameEn: 'Paraguay',
    nameDe: 'Paraguay',
  ),
  Country(
    alpha2: 'pe',
    nameEn: 'Peru',
    nameDe: 'Peru',
  ),
  Country(
    alpha2: 'ph',
    nameEn: 'Philippines',
    nameDe: 'Philippinen',
  ),
  Country(
    alpha2: 'pn',
    nameEn: 'Pitcairn',
    nameDe: 'Pitcairninseln',
  ),
  Country(
    alpha2: 'pl',
    nameEn: 'Poland',
    nameDe: 'Polen',
  ),
  Country(
    alpha2: 'pt',
    nameEn: 'Portugal',
    nameDe: 'Portugal',
  ),
  Country(
    alpha2: 'pr',
    nameEn: 'Puerto Rico',
    nameDe: 'Puerto Rico',
  ),
  Country(
    alpha2: 'qa',
    nameEn: 'Qatar',
    nameDe: 'Katar',
  ),
  Country(
    alpha2: 'ro',
    nameEn: 'Romania',
    nameDe: 'Rumänien',
  ),
  Country(
    alpha2: 'ru',
    nameEn: 'Russian Federation',
    nameDe: 'Russland',
  ),
  Country(
    alpha2: 'rw',
    nameEn: 'Rwanda',
    nameDe: 'Ruanda',
  ),
  Country(
    alpha2: 're',
    nameEn: 'Réunion',
    nameDe: 'Réunion',
  ),
  Country(
    alpha2: 'bl',
    nameEn: 'Saint Barthélemy',
    nameDe: 'Saint-Barthélemy',
  ),
  Country(
    alpha2: 'sh',
    nameEn: 'Saint Helena, Ascension and Tristan da Cunha',
    nameDe: 'St. Helena, Ascension und Tristan da Cunha',
  ),
  Country(
    alpha2: 'kn',
    nameEn: 'Saint Kitts and Nevis',
    nameDe: 'St. Kitts und Nevis',
  ),
  Country(
    alpha2: 'lc',
    nameEn: 'Saint Lucia',
    nameDe: 'St. Lucia',
  ),
  Country(
    alpha2: 'mf',
    nameEn: 'Saint Martin (French part)',
    nameDe: 'Saint-Martin (französischer Teil)',
  ),
  Country(
    alpha2: 'pm',
    nameEn: 'Saint Pierre and Miquelon',
    nameDe: 'Saint-Pierre und Miquelon',
  ),
  Country(
    alpha2: 'vc',
    nameEn: 'Saint Vincent and the Grenadines',
    nameDe: 'St. Vincent und die Grenadinen',
  ),
  Country(
    alpha2: 'ws',
    nameEn: 'Samoa',
    nameDe: 'Samoa',
  ),
  Country(
    alpha2: 'sm',
    nameEn: 'San Marino',
    nameDe: 'San Marino',
  ),
  Country(
    alpha2: 'st',
    nameEn: 'Sao Tome and Principe',
    nameDe: 'São Tomé und Príncipe',
  ),
  Country(
    alpha2: 'sa',
    nameEn: 'Saudi Arabia',
    nameDe: 'Saudi-Arabien',
  ),
  Country(
    alpha2: 'sn',
    nameEn: 'Senegal',
    nameDe: 'Senegal',
  ),
  Country(
    alpha2: 'rs',
    nameEn: 'Serbia',
    nameDe: 'Serbien',
  ),
  Country(
    alpha2: 'sc',
    nameEn: 'Seychelles',
    nameDe: 'Seychellen',
  ),
  Country(
    alpha2: 'sl',
    nameEn: 'Sierra Leone',
    nameDe: 'Sierra Leone',
  ),
  Country(
    alpha2: 'sg',
    nameEn: 'Singapore',
    nameDe: 'Singapur',
  ),
  Country(
    alpha2: 'sx',
    nameEn: 'Sint Maarten (Dutch part)',
    nameDe: 'Sint Maarten',
  ),
  Country(
    alpha2: 'sk',
    nameEn: 'Slovakia',
    nameDe: 'Slowakei',
  ),
  Country(
    alpha2: 'si',
    nameEn: 'Slovenia',
    nameDe: 'Slowenien',
  ),
  Country(
    alpha2: 'sb',
    nameEn: 'Solomon Islands',
    nameDe: 'Salomonen',
  ),
  Country(
    alpha2: 'so',
    nameEn: 'Somalia',
    nameDe: 'Somalia',
  ),
  Country(
    alpha2: 'za',
    nameEn: 'South Africa',
    nameDe: 'Südafrika',
  ),
  Country(
    alpha2: 'gs',
    nameEn: 'South Georgia and the South Sandwich Islands',
    nameDe: 'Südgeorgien und die Südlichen Sandwichinseln',
  ),
  Country(
    alpha2: 'ss',
    nameEn: 'South Sudan',
    nameDe: 'Südsudan',
  ),
  Country(
    alpha2: 'es',
    nameEn: 'Spain',
    nameDe: 'Spanien',
  ),
  Country(
    alpha2: 'lk',
    nameEn: 'Sri Lanka',
    nameDe: 'Sri Lanka',
  ),
  Country(
    alpha2: 'sd',
    nameEn: 'Sudan',
    nameDe: 'Sudan',
  ),
  Country(
    alpha2: 'sr',
    nameEn: 'Suriname',
    nameDe: 'Suriname',
  ),
  Country(
    alpha2: 'sj',
    nameEn: 'Svalbard and Jan Mayen',
    nameDe: 'Spitzbergen und Jan Mayen',
  ),
  Country(
    alpha2: 'se',
    nameEn: 'Sweden',
    nameDe: 'Schweden',
  ),
  Country(
    alpha2: 'ch',
    nameEn: 'Switzerland',
    nameDe: 'Schweiz',
  ),
  Country(
    alpha2: 'sy',
    nameEn: 'Syrian Arab Republic',
    nameDe: 'Syrien',
  ),
  Country(
    alpha2: 'tw',
    nameEn: 'Taiwan, Province of China',
    nameDe: 'China, Republik',
  ),
  Country(
    alpha2: 'tj',
    nameEn: 'Tajikistan',
    nameDe: 'Tadschikistan',
  ),
  Country(
    alpha2: 'tz',
    nameEn: 'Tanzania, United Republic of',
    nameDe: 'Tansania',
  ),
  Country(
    alpha2: 'th',
    nameEn: 'Thailand',
    nameDe: 'Thailand',
  ),
  Country(
    alpha2: 'tl',
    nameEn: 'Timor-Leste',
    nameDe: 'Osttimor',
  ),
  Country(
    alpha2: 'tg',
    nameEn: 'Togo',
    nameDe: 'Togo',
  ),
  Country(
    alpha2: 'tk',
    nameEn: 'Tokelau',
    nameDe: 'Tokelau',
  ),
  Country(
    alpha2: 'to',
    nameEn: 'Tonga',
    nameDe: 'Tonga',
  ),
  Country(
    alpha2: 'tt',
    nameEn: 'Trinidad and Tobago',
    nameDe: 'Trinidad und Tobago',
  ),
  Country(
    alpha2: 'tn',
    nameEn: 'Tunisia',
    nameDe: 'Tunesien',
  ),
  Country(
    alpha2: 'tm',
    nameEn: 'Turkmenistan',
    nameDe: 'Turkmenistan',
  ),
  Country(
    alpha2: 'tc',
    nameEn: 'Turks and Caicos Islands',
    nameDe: 'Turks- und Caicosinseln',
  ),
  Country(
    alpha2: 'tv',
    nameEn: 'Tuvalu',
    nameDe: 'Tuvalu',
  ),
  Country(
    alpha2: 'tr',
    nameEn: 'Türkiye',
    nameDe: 'Türkei',
  ),
  Country(
    alpha2: 'ug',
    nameEn: 'Uganda',
    nameDe: 'Uganda',
  ),
  Country(
    alpha2: 'ua',
    nameEn: 'Ukraine',
    nameDe: 'Ukraine',
  ),
  Country(
    alpha2: 'ae',
    nameEn: 'United Arab Emirates',
    nameDe: 'Vereinigte Arabische Emirate',
  ),
  Country(
    alpha2: 'gb',
    nameEn: 'United Kingdom of Great Britain and Northern Ireland',
    nameDe: 'Vereinigtes Königreich',
  ),
  Country(
    alpha2: 'um',
    nameEn: 'United States Minor Outlying Islands',
    nameDe: 'United States Minor Outlying Islands',
  ),
  Country(
    alpha2: 'us',
    nameEn: 'United States of America',
    nameDe: 'Vereinigte Staaten',
  ),
  Country(
    alpha2: 'uy',
    nameEn: 'Uruguay',
    nameDe: 'Uruguay',
  ),
  Country(
    alpha2: 'uz',
    nameEn: 'Uzbekistan',
    nameDe: 'Usbekistan',
  ),
  Country(
    alpha2: 'vu',
    nameEn: 'Vanuatu',
    nameDe: 'Vanuatu',
  ),
  Country(
    alpha2: 've',
    nameEn: 'Venezuela (Bolivarian Republic of)',
    nameDe: 'Venezuela',
  ),
  Country(
    alpha2: 'vn',
    nameEn: 'Viet Nam',
    nameDe: 'Vietnam',
  ),
  Country(
    alpha2: 'vg',
    nameEn: 'Virgin Islands (British)',
    nameDe: 'Britische Jungferninseln',
  ),
  Country(
    alpha2: 'vi',
    nameEn: 'Virgin Islands (U.S.)',
    nameDe: 'Amerikanische Jungferninseln',
  ),
  Country(
    alpha2: 'wf',
    nameEn: 'Wallis and Futuna',
    nameDe: 'Wallis und Futuna',
  ),
  Country(
    alpha2: 'eh',
    nameEn: 'Western Sahara',
    nameDe: 'Westsahara',
  ),
  Country(
    alpha2: 'ye',
    nameEn: 'Yemen',
    nameDe: 'Jemen',
  ),
  Country(
    alpha2: 'zm',
    nameEn: 'Zambia',
    nameDe: 'Sambia',
  ),
  Country(
    alpha2: 'zw',
    nameEn: 'Zimbabwe',
    nameDe: 'Simbabwe',
  ),
  Country(
    alpha2: 'ax',
    nameEn: 'Åland Islands',
    nameDe: 'Åland',
  ),
];
