/// ISO-2 codes of countries we surface at the top of the Shop list. Mirrors
/// `POPULAR_COUNTRY_CODES` in the H5 `services/esimApi.ts`.
const kPopularCountryCodes = <String>{
  'MX', 'CA', 'JP', 'GB', 'FR', 'IT', 'KR', 'TH', 'DO', 'DE', 'ES', 'CO',
};

bool isPopularCountry(String code) =>
    kPopularCountryCodes.contains(code.toUpperCase());
