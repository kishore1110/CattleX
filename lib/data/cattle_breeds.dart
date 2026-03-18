class CattleBreeds {
  static String getDetailedDescription(String breedName) {
    switch (breedName) {
      case 'Gir':
        return '''
Colour: Red with white patches. The face and lower abdomen are white in colour with black muzzle.

Horn Shape & Size: Curved upward and inward, sickle shaped.

Characteristics: Medium sized strong dual type, and migratory animal of lower Himalayas. White face along with some regions of Hump, neck, and dewlap are white. In males, Hump and neck region are dark in colour irrespective of coat colour.

Origin: Gujarat, India. The Gir breed is one of the most important zebu breeds of India.

Physical Features: The average body weight of adult bulls is 545 kg and adult cows is 385 kg. The average milk yield is 1590 kg per lactation.

Special Qualities: Known for heat tolerance, disease resistance, and good mothering ability. Excellent for crossbreeding programs.''';

      case 'Sahiwal':
        return '''
Colour: Brownish red; shades may vary from mahogany red-brown to more greyish red. Extremities in bulls are darker. Occasionally there are white patches.

Horn Shape & Size: Pale red colour, stumpy horns, short to medium size, running outwards, upwards and then inwards. Loose skin.

Characteristics: Heat tolerant, good milkers in tropical climates, well adapted to stall-fed and grazing systems.

Milk Yield: 15-20 L/day (varies); high butterfat content and durable in hot conditions.''';

      case 'Red Sindhi':
        return '''
Colour: Distinctly red; shades vary from dark red to dim yellow. Patches of white may appear on dewlap or forehead, but no large white patches on the body. In bulls, colour is dark on shoulders and thighs.

Horn Shape & Size: Thick at the base, emerge laterally and curve upward.

Characteristics: Hardy, heat-tolerant dairy breed with good temperament and milking ability.

Milk Yield: 10-15 L/day; widely used in tropical crossbreeding programs.''';

      case 'Amritmahal':
        return '''
Colour: Grey, but varies from white to almost black. White-grey markings may be present on face and dewlap.

Horn Shape & Size: Long horns, emerging close together from the poll, directed backward and upward, turning inward with sharp black points, sometimes touching each other.

Visible Characteristic: Long head tapering towards muzzle.

Characteristics: Strong, hardy draft breed, valued for draught and low milk.

Milk Yield: 2-3 L/day (low); primarily a draught/draft animal.''';

      case 'Bachaur':
        return '''
Colour: Grey.

Horn Shape & Size: Stumpy, curving outward and upward. Medium in size.

Visible Characteristic: Medium-sized compact animals with straight back. Forehead flat or slightly convex.

Characteristics: Drought-resistant, medium-sized, used for both milk and draft.

Milk Yield: 6-8 L/day (approx.).''';

      case 'Badri':
        return '''
Colour: Varied – Black, Brown, Red, White or Grey (small-sized).

Horn Shape & Size: Small horns. Long legs, prominent hump, small udder tucked up.

Visible Characteristic: Hooves and muzzle are black or brown. Hump prominent.

Characteristics: Hardy dual-purpose, adapted to hot climates.

Milk Yield: 4-6 L/day (approx.).''';

      case 'Bargur':
        return '''
Colour: Brown with white markings.

Horn Shape & Size: Medium-sized, light brown. Horns close at root, inclined backward, outward, upward, with a forward curve, sharp at tip.

Visible Characteristic: Brown coat with white markings, light brown horns.

Characteristics: Strong draught breed from Tamil Nadu, hardy and disease-resistant.

Milk Yield: 2-3 L/day (low; mainly draught).''';

      case 'Belahi':
        return '''
Colour: Red; face, lower abdomen, and feet are white with black muzzle.

Horn Shape & Size: Curved upward and inward, sickle shaped.

Characteristics: Medium-sized, strong dual type, migratory animal. In males, hump and neck are darker.

Milk Yield: 2-4 L/day (low).''';

      case 'Binjharpuri':
        return '''
Colour: White. Some animals are Grey, Black or Brown.

Horn Shape & Size: Curved upward and inward.

Average size: Male: 21.17±2.86 cm, Female: 12.70±1.31 cm.

Visible Characteristic: Medium sized, strong dual type. Hump, neck, and some region of face and back are black in males.

Characteristics: Indigenous dairy breed from Odisha; sturdy and medium-sized.

Milk Yield: 8-10 L/day (approx.).''';

      case 'Dagri':
        return '''
Colour: Predominantly white, sometimes with grey shade.

Horn Shape & Size: Short, thin, curved upward in a lyre shape or straight with pointed tip.

Visible Characteristic: Small sized animal, compact body, straight forehead. Body length proportionally more than height.

Characteristics: Hardy draught breed from Himachal Pradesh.

Milk Yield: 2-3 L/day (low).''';

      case 'Dangi':
        return '''
Colour: Distinct white coat with red or black spots unevenly distributed.

Horn Shape & Size: Short (12-15 cm), thick, lateral pointing tips; variations exist.

Visible Characteristic: Uneven black or red spots; slightly protruding forehead.

Characteristics: Sturdy draught breed from Maharashtra; disease-resistant.

Milk Yield: 4-6 L/day (approx.).''';

      case 'Deoni':
        return '''
Colour: Usually spotted black and white. Three strains: complete white (balankya), white with partial black face (wannera), black & white spotted (waghyd).

Horn Shape & Size: Emerge from side of poll, outward and upward, slightly backward and then curving upward. Small size with blunt tips.

Visible Characteristic: Drooping ears, prominent and slightly bulging forehead.

Characteristics: Dual-purpose breed from Maharashtra; useful for both milk and draft.

Milk Yield: 8-10 L/day (approx.).''';

      /* ----- Newly added breeds ----- */

      case 'Gangatiri':
        return '''
Coat colour: Complete white (Dhawar) or Grey (Sokan).

Horn Shape & Size: Medium-sized horns emerging from side of poll behind and above eyes; curving upwards and inwards with pointed tips.

Visible Characteristic: Prominent, straight and broad forehead with a shallow groove in the middle. Eyelids, muzzle, hooves and tail switch generally black.

Characteristics: Medium-frame dual-purpose breed from Ganga belt; moderately hardy.

Milk Yield: ~3.96 L/day (≈1050 kg per lactation).''';

      case 'Gaolao':
        return '''
Colour: White or light grey. Males often grey over the neck.

Horn Shape & Size: Short, stumpy, blunt at points; curve slightly backward.

Visible Characteristic: Long, narrow head tapering towards muzzle. Forehead recedes slightly giving a convex appearance. Almond-shaped eyes at slight angle.

Characteristics: Lighter Ongole-type; agile draft and milch traits.

Milk Yield: ≈604 kg per lactation (range: 470-725 kg) (~2.4-3.0 L/day).''';

      case 'Ghumusari':
        return '''
Colour: Mainly white, sometimes grey.

Horn Shape & Size: Curved upward and inward; some animals have straight horns. Male: 8.72±1.54 cm, Female: 7.47±1.67 cm.

Visible Characteristic: Small-sized, strong draft type with small head and broad flat forehead.

Characteristics: Small, sturdy draft cattle; heat tolerant and low-feed requirement.

Milk Yield: ~450-650 kg per lactation (~1.7-2.4 L/day).''';

      case 'Hallikar':
        return '''
Colour: Grey to dark grey with deep shadings on forehead and hind quarters; light grey markings on face, dewlap and underbody common.

Horn Shape & Size: Emerge near each other from poll, carried backward then bend forward and slightly inward toward black sharp tips.

Visible Characteristic: Compact, strong-bodied animals used for draught.

Characteristics: Famous southern India draught breed, strong oxen and modest milkers.

Milk Yield: ~542 kg per lactation (range 227-1,134 kg) ≈1.9-3.9 L/day.''';

      case 'Hariana':
        return '''
Colour: White or light grey; bulls may be darker between fore and hind quarters.

Horn Shape & Size: Small horns.

Characteristics: Dual-purpose northern Indian breed; strong draft capability and hardy.

Milk Yield: ~997 kg per lactation on average (range ~693-1745 kg).''';

      case 'Himachali Pahari':
        return '''
Colour: Primarily black and blackish brown.

Horn Shape & Size: Medium sized, mainly curved laterally and upward.

Visible Characteristic: Compact cylindrical body, short legs, medium hump, horizontally placed ears.

Characteristics: Small, hardy draught breed adapted to hilly terrain.

Milk Yield: Average lactation yield ~538 kg (range: 300–650 kg); daily 1–3 L.''';

      case 'Kangayam':
        return '''
Colour: Reddish at birth, turning grey by 6 months. Bulls grey with darker hump, fore and hind quarters. Cows grey or white/grey; occasional red/black/fawn.

Horn Shape & Size: Long strong horns sweeping backward, outward and upward then curving inward; nearly meeting in a circle.

Visible Characteristic: Large hump and strong compact body.

Characteristics: Hardy draught breed from Tamil Nadu; energetic and compact.

Milk Yield: Avg. lactation ~540 kg (~1.5–3.0 L/day). Fat ~3.9%.''';

      case 'Kankrej':
        return '''
Colour: Varies from silver-grey to iron/steel grey. Males darker in fore & hind quarters and hump.

Horn Shape & Size: Strong, lyre-shaped horns curved outward and upward.

Visible Characteristic: Heavier breed; large pendulous ears.

Characteristics: Dual-purpose from Gujarat & Rajasthan; drought-resistant and good milk potential.

Milk Yield: Avg. lactation ~1,746 kg (high butterfat ~4.8%).''';

      case 'Kenkatha':
        return '''
Colour: Grey on barrel to dark grey elsewhere.

Horn Shape & Size: Horns emerge from outer angles of poll directed forward terminating in sharp points.

Visible Characteristic: Small, sturdy and fairly powerful animal; horns directed forwards.

Characteristics: Hardy draught breed.

Milk Yield: Avg. lactation 500–600 kg (1.0–3.0 L/day); peak yields up to 5.0 kg/day observed.''';

      case 'Khariar':
        return '''
Colour: Mainly brown, sometimes grey.

Horn Shape & Size: Straight or upward and inward.

Male: 12.34±0.21 cm, Female: 10.12±0.27 cm.

Visible Characteristic: Small-sized strong draft animal; hump and neck darker in colour.

Characteristics: Hardy draught breed from Odisha.

Milk Yield: Avg. lactation 300–450 kg; fat 4–5%.''';

      case 'Kherigarh':
        return '''
Colour: Predominantly white; some animals show grey on face.

Horn Shape & Size: Upstanding, curving outward and upward; thick at base (lyre-horned Malvi type); medium ~15 cm.

Visible Characteristic: Small but active animal.

Characteristics: Draught breed from Uttar Pradesh.

Milk Yield: Avg. lactation 300–500 kg.''';

      case 'Khillar':
        return '''
Colour: Greyish white types, with males darker over fore & hind quarters; some types have carroty nose/hooves.

Horn Shape & Size: Long, pointed, following backward curve of head, placed close at root and turn upward in bow shape.

Visible Characteristic: Distinct groove in centre of forehead.

Characteristics: Compact draught-adapted breed from Maharashtra.

Milk Yield: Avg. daily ~2.42 L; lactation length ~189 days; fat ~4.22%.''';

      case 'Konkan Kapila':
        return '''
Colour: Various, predominant reddish brown followed by black; white/grey and mixed types exist.

Horn Shape & Size: Generally straight, emerge behind and above eyes, pointing outward/upward/backward ending in pointed tips.

Visible Characteristic: Small to medium compact body, black eyelids/muzzle/hooves/tail switch.

Characteristics: Hardy draught breed from Konkan, Maharashtra; heat-tolerant.

Milk Yield: Avg. lactation ~450 kg; daily ~2.25 L; fat ~4.5%.''';

      case 'Kosali':
        return '''
Colour: Mainly light red (60-65%) or whitish grey (30-35%). Few black or red-with-white-patches animals.

Horn Shape & Size: Stumpy and straight; ~21 cm in males and ~12 cm in females.

Visible Characteristic: Black muzzle, eyelids, tail switch and hooves; broad straight head; small-medium hump.

Characteristics: Small hardy draught breed from Chhattisgarh.

Milk Yield: Avg. lactation ~210 kg; peak ~1.27 kg/day; fat ~4.4%.''';

      case 'Krishna Valley':
        return '''
Colour: Grey-white with darker shade on fore & hind quarters in males; females more whitish. Variants include brown & white, black & white.

Horn Shape & Size: Curved, usually outward then slightly upward and inward; usually small horns.

Visible Characteristic: Massive body and distinct bulge in forehead.

Characteristics: Massive draught breed from northern Karnataka.

Milk Yield: Avg. lactation ~900–1,200 kg; daily avg ~2.6 kg.''';

      case 'Ladakhi':
        return '''
Colour: Mostly black followed by brown.

Horn Shape & Size: Curved, directed slightly upward and forward ending with pointed tips over forehead. Male avg ~16 cm, female ~11 cm.

Visible Characteristic: Compact body with short legs adapted to high altitudes; small hairy forehead and small hump.

Characteristics: Well adapted to high altitude, extreme cold and hypoxic conditions.

Milk Yield: Avg. daily 2–5 kg; milk fat ~5%.''';

      case 'Lakhimi':
        return '''
Colour: Brown & Grey; small sized with relatively short legs.

Visible Characteristic: Small compact body, medium hump, small bowl-shaped udder.

Characteristics: Small draught breed; hardy and compact.

Milk Yield: Avg. daily 2–5 kg; milk fat ~5%.''';

      case 'Malnad':
        return '''
Colour: Black with light shades of fawn on thigh and shoulder region.

Horn Shape & Size: Generally small and straight, outward/upward/inward.

Visible Characteristic: Small size (80–120 kg), compact body; small hump; small bowl-shaped udder.

Characteristics: Dwarf-type hardy draught breed from heavy rainfall regions of Karnataka.

Milk Yield: Avg. daily ~1.61 L; lactation ~9 months.''';

      case 'Malvi':
        return '''
Colour: Grey, darker in males; neck, shoulders, hump and quarters almost black. Cows and bullocks may become nearly white with age.

Horn Shape & Size: Strong and pointed; lyre-shaped; avg. 20-25 cm.

Visible Characteristic: Strong well-built whitish-grey animal.

Characteristics: Hardy draught breed from Madhya Pradesh.

Milk Yield: Avg. lactation ~916 kg (range 627–1,227 kg); fat ~4.3%.''';

      case 'Mewati':
        return '''
Colour: Usually white with darker neck, shoulders and quarters.

Horn Shape & Size: Mostly outwards/upwards/inwards; tips pointed.

Visible Characteristic: Long narrow face and sometimes slightly bulging forehead.

Characteristics: Hardy dual-purpose breed from Haryana, Rajasthan and Uttar Pradesh.

Milk Yield: Avg. lactation ~958 kg; daily ≈5 kg peak in some animals.''';

      case 'Motu':
        return '''
Colour: Mainly brown (reddish), sometimes grey; some animals white.

Horn Shape & Size: Straight, upward with rounded tip. Male: ~6.23 cm, Female: ~3.35 cm.

Visible Characteristic: Small-sized, strong draft type; mostly polled and brown in colour.

Characteristics: Small hardy draught breed from Odisha.

Milk Yield: Avg. lactation 100–140 kg; high fat content 4.8–5.3%.''';

      case 'Nagori':
        return '''
Colour: White to light grey.

Horn Shape & Size: Medium-sized, upward-curving horns.

Visible Characteristic: Compact muscular body adapted to semi-arid conditions.

Characteristics: Dual-purpose breed from Rajasthan; hardy, thrifty on limited fodder and calm temperament.

Milk Yield: ~8–12 L/day (field reports; varies).''';

      case 'Nari':
        return '''
Colour: Usually white or greyish white; bulls may be white, greyish white or black.

Horn Shape & Size: Spirally curved, outward/forward; long, widely spread and thick at base.

Visible Characteristic: Broad slightly concave forehead; medium-sized body.

Characteristics: Small draught breed from Madhya Pradesh.

Milk Yield: Avg. lactation 250–400 kg; fat 4–5%.''';

      case 'Nimari':
        return '''
Colour: Light grey to white.

Horn Shape & Size: Strong, suitable for draught.

Visible Characteristic: Medium to large frame with well-set hooves.

Characteristics: Draught and milch breed from Nimar (Madhya Pradesh); adaptable to semi-arid conditions.

Milk Yield: ~6–9 L/day (6–9 liters/day reported).''';

      case 'Ongole':
        return '''
Colour: Glossy white (Padakateeru). Males have dark grey markings on head, neck, hump; black points on knees and pasterns, black muzzle and eye-lashes.

Horn Shape & Size: Short, stumpy, thick at base; extend outward and backward.

Visible Characteristic: Majestic gait, stumpy horns, large fan-shaped dewlap with smooth folds.

Characteristics: Large, muscular breed from Andhra Pradesh; heat-resistant and prized globally; used for crossbreeding.

Milk Yield: Avg. lactation 850–2,518 kg; high butterfat (>5%).''';

      case 'Poda Thurpu':
        return '''
Colour: White with light to dark brown patches or red/brown with white patches.

Horn Shape & Size: Broad at base; mostly straight sometimes curved.

Visible Characteristic: Compact medium-sized cattle with convex forehead and deep central groove.

Characteristics: Hardy draught breed from Telangana; spotted coat and drought tolerant.

Milk Yield: Avg. lactation 494–646 kg.''';

      case 'Ponwar':
        return '''
Colour: Brown or black with white patches intermixed; pattern variable.

Horn Shape & Size: Emerge outward, upward and curve inward with pointed tips; medium-sized.

Visible Characteristic: Active and hardy.

Characteristics: Draught breed from Uttar Pradesh.

Milk Yield: Avg. lactation ~460 kg; daily 0.5–2.5 kg.''';

      case 'Pulikulam':
        return '''
Colour: Dark grey in males; white or grey in females.

Horn Shape & Size: Curved outwards, upwards, backwards and inwards ending with pointed tips. Male ~34.34 cm, Female ~37.22 cm.

Visible Characteristic: Small, compact body with short legs; black muzzle/eyelids/tail/hooves.

Characteristics: Hardy draught and game breed from Tamil Nadu.

Milk Yield: Avg. daily 0.5–3.0 kg; avg ~1.25 kg.''';

      case 'Punganur':
        return '''
Colour: White, grey or light brown to dark brown; mixes and patches common.

Horn Shape & Size: Crescent shaped, small (10–15 cm), sometimes stumpy.

Visible Characteristic: Very compact, dwarf-sized; prized for high-fat ghee production.

Characteristics: Drought-resistant compact breed from Andhra Pradesh; famed for ghee.

Milk Yield: Avg. lactation ~466.86 kg over 238.59 days; peak ~2.72 kg/day; fat ~5%.''';

      case 'Purnea':
        return '''
Colour: Primarily grey followed by red and black.

Horn Shape & Size: Straight and mostly carried upwards sometimes laterally. Male ~8.3 cm, Female ~7.1 cm.

Visible Characteristic: Small sized animals with medium hump and small udder.

Characteristics: Small-sized hardy cattle from Bihar used for milk and draught.

Milk Yield: Avg. lactation 452–785 kg; avg ~609 kg; fat ~4.2%.''';

      case 'Rathi':
        return '''
Colour: Usually brown with white patches; some completely brown or black with white patches.

Horn Shape & Size: Curving outward, upward and inward; short to medium sized.

Visible Characteristic: Medium-sized dual-purpose animal.

Characteristics: Dual-purpose breed from Rajasthan; good milkers and draught.

Milk Yield: Avg. lactation 1,500–1,800 kg; fat ~4–5%.''';

      case 'Red Kandhari':
        return '''
Colour: Uniform deep dark red to brown.

Horn Shape & Size: Evenly curved and medium sized.

Visible Characteristic: Distinct deep red coat.

Characteristics: Native Maharashtra breed; hardy and drought-resistant, used for milk and draught.

Milk Yield: Avg. lactation 1,800–2,000 kg; fat ~4–5%.''';

      case 'Shweta Kapila':
        return '''
Coat colour: White throughout (including eyelashes and muzzle area whitish brown).

Horn Shape & Size: Straight and slightly curved upward/outward; size 20–27 cm.

Visible Characteristic: Short to medium stature, straight face, small-medium hump.

Characteristics: White-coloured dual-purpose breed with good milk and draft capabilities.

Milk Yield: Avg. lactation 1,800–2,200 kg; fat ~4–5%.''';

      case 'Siri':
        return '''
Colour: Black with white patches or brown with white patches; sometimes totally black or brown.

Horn Shape & Size: Curved outward, forward and slightly upward; medium sized.

Visible Characteristic: Colour pattern reminiscent of Holstein Friesian; cervico-thoracic hump.

Characteristics: Indigenous hill cattle; hardy and disease-resistant; low maintenance.

Milk Yield: Produces 2–6 kg daily; fat 2.8–5.5%.''';

      case 'Tharparkar':
        return '''
Colour: White or light grey with darker face and extremities.

Horn Shape & Size: Set apart curving gradually upward and outward with blunt inward-inclined points.

Visible Characteristic: Convex forehead; bulls darker on neck and quarters.

Characteristics: Dual-purpose from Rajasthan; hardy, heat-tolerant with good draught ability.

Milk Yield: 8–10 kg/day; avg ~1,749 kg per lactation.''';

      case 'Thutho':
        return '''
Colour: Black or brown, sometimes with white patches.

Horn Shape & Size: Curved outward and upward; short and stumpy.

Visible Characteristic: Medium-sized, hardy, well-built and docile; forehead small and straight.

Characteristics: Indigenous small cattle used for draught and milk.

Milk Yield: 1–3 kg/day; lactation ~152 days.''';

      case 'Umblachery':
        return '''
Colour: Calves red or brown at birth turning grey by 6 months; adult females predominantly grey with white markings on face and legs.

Horn Shape & Size: Curving outward and inward; thick in bulls, thin in cows; very small horns.

Visible Characteristic: White markings on face, limbs and tail; legs below hocks often have white socks.

Characteristics: Hardy Tamil Nadu breed suitable for drought-prone areas.

Milk Yield: ~2 kg/day with ~4.94% fat.''';

      case 'Vechur':
        return '''
Colour: Light red, black or fawn and white.

Horn Shape & Size: Small, thin horns curving forward and downward; sometimes extremely small.

Visible Characteristic: Extremely small sized animal (very dwarf).

Characteristics: Small Kerala breed known for high-quality A2 milk.

Milk Yield: 3–4 kg/day; fat 4.7–5.8%.''';

      default:
        return 'Detailed information about this cattle breed will be available soon. Please visit the official Pashupedia website for more comprehensive breed information.';
    }
  }

  static List<Map<String, String>> getCattleBreeds() {
    return [
      // Existing breeds (kept as originally provided)
      {
        'title': 'Gir',
        'description':
            'Indigenous breed from Gujarat known for high milk yield and disease resistance.',
        'image': 'assets/images/gir_cattle.jpg',
        'yield': '15-20L/day',
      },
      {
        'title': 'Red Sindhi',
        'description':
            'Hardy cattle breed known for heat tolerance and good milk production.',
        'image': 'assets/images/Red Sindhi.jpg',
        'yield': '10-15L/day',
      },
      {
        'title': 'Sahiwal',
        'description':
            'Heat-resistant breed with excellent milk production in tropical climates.',
        'image': 'assets/images/Sahiwal.jpg',
        'yield': '15-20L/day',
      },
      {
        'title': 'Amritmahal',
        'description': 'Strong, hardy, draft animal, grey-white, low milk.',
        'image': 'assets/images/Amritmahal.jpg',
        'yield': '2-3L/day',
      },
      {
        'title': 'Bachaur',
        'description':
            'Indigenous Indian breed, medium-sized, drought-resistant, primarily for milk.',
        'image': 'assets/images/Bachaur.jpg',
        'yield': '6-8L/day',
      },
      {
        'title': 'Badri',
        'description':
            'Indigenous Indian breed, hardy, dual-purpose, suited for hot climates.',
        'image': 'assets/images/Badri.jpg',
        'yield': '4-6L/day',
      },
      {
        'title': 'Bargur',
        'description':
            'Strong, draught breed from Tamil Nadu, hardy, disease-resistant.',
        'image': 'assets/images/Bargur.jpg',
        'yield': '2-3L/day',
      },
      {
        'title': 'Belahi',
        'description':
            'Indigenous breed, hardy, adaptable, primarily used for draft purposes.',
        'image': 'assets/images/Belahi.jpg',
        'yield': '2-4L/day',
      },
      {
        'title': 'Binjharpuri',
        'description':
            'Indigenous dairy breed from Odisha, sturdy, medium-sized, well-built.',
        'image': 'assets/images/Binjharpuri.jpg',
        'yield': '8-10L/day',
      },
      {
        'title': 'Dagri',
        'description':
            'Indigenous draught breed from Himachal Pradesh, small, hardy, sure-footed.',
        'image': 'assets/images/Dagri.jpg',
        'yield': '2-3L/day',
      },
      {
        'title': 'Dangi',
        'description':
            'Indigenous draught breed from Maharashtra, sturdy, disease-resistant, rain-tolerant.',
        'image': 'assets/images/Dangi.jpg',
        'yield': '4-6L/day',
      },
      {
        'title': 'Deoni',
        'description':
            'Dual-purpose breed from Maharashtra, hardy, good for milk and draught.',
        'image': 'assets/images/Deoni.jpg',
        'yield': '8-10L/day',
      },

      {
        'title': 'Gangatiri',
        'description':
            'Medium-frame dual-purpose breed from Ganga belt, white-grey coat',
        'image': 'assets/images/Gangatiri.jpg',
        'yield': '≈4L/day',
      },
      {
        'title': 'Gaolao',
        'description':
            'Lighter Ongole-type, agile draft-milk cattle, white/grey coat traits.',
        'image': 'assets/images/Gaolao.jpg',
        'yield': '≈2.4-3.0L/day',
      },
      {
        'title': 'Ghumusari',
        'description':
            'Small, sturdy draft cattle; white-grey coat; heat tolerant, low feed.',
        'image': 'assets/images/Ghumusari.jpg',
        'yield': '≈1.7-2.4L/day',
      },
      {
        'title': 'Hallikar',
        'description':
            'Southern India draught breed; grey coat; strong, compact oxen, modest milk.',
        'image': 'assets/images/Hallikar.jpg',
        'yield': '≈1.9-3.9L/day',
      },
      {
        'title': 'Hariana',
        'description':
            'Dual-purpose northern Indian breed; strong draft; hardy; light grey coat.',
        'image': 'assets/images/Hariana.jpg',
        'yield': '≈997 kg/lactation',
      },
      {
        'title': 'Himachali Pahari',
        'description':
            'Small, hardy draught breed; black coat; adapted to hilly terrain.',
        'image': 'assets/images/Himachali Pahari.jpg',
        'yield': '≈1-3L/day',
      },
      {
        'title': 'Kangayam',
        'description':
            'Hardy draught breed from Tamil Nadu; grey coat; compact build.',
        'image': 'assets/images/Kangayam.jpg',
        'yield': '≈1.5-3.0L/day',
      },
      {
        'title': 'Kankrej',
        'description':
            'Dual-purpose breed from Gujarat and Rajasthan; lyre-shaped horns; drought-resistant.',
        'image': 'assets/images/Kankrej.jpg',
        'yield': '≈4.8% fat, ~1746 kg/lactation',
      },
      {
        'title': 'Kenkatha',
        'description':
            'Small, sturdy draught breed; grey to dark grey coat; hardy.',
        'image': 'assets/images/Kenkatha.jpg',
        'yield': '≈500-600 kg/lactation',
      },
      {
        'title': 'Khariar',
        'description':
            'Small, hardy draught breed from Odisha; brown-grey coat; straight horns.',
        'image': 'assets/images/Khariar.jpg',
        'yield': '≈300-450 kg/lactation',
      },
      {
        'title': 'Kherigarh',
        'description':
            'Small, active draught breed from Uttar Pradesh; white-grey coat.',
        'image': 'assets/images/Kherigarh.jpg',
        'yield': '≈300-500 kg/lactation',
      },
      {
        'title': 'Khillar',
        'description':
            'Compact, draught adapted breed from Maharashtra; grey white coat; sturdy build.',
        'image': 'assets/images/Khillar.jpg',
        'yield': '≈2.4L/day',
      },
      {
        'title': 'Konkan Kapila',
        'description':
            'Small, hardy draught breed from Maharashtra; reddish-brown coat; heat-tolerant.',
        'image': 'assets/images/Konkan Kapila.jpg',
        'yield': '≈450 kg/lactation',
      },
      {
        'title': 'Kosali',
        'description':
            'Small, hardy draught breed from Chhattisgarh; red or grey coat.',
        'image': 'assets/images/Kosali.jpg',
        'yield': '≈210 kg/lactation',
      },
      {
        'title': 'Krishna Valley',
        'description':
            'Massive draught breed from northern Karnataka; grayish-white coat; hardy.',
        'image': 'assets/images/Krishna Valley.jpg',
        'yield': '≈900-1,200 kg/lactation',
      },
      {
        'title': 'Ladakhi',
        'description':
            'Compact, hardy draught breed from Ladakh; black coat; high-fat milk.',
        'image': 'assets/images/Ladakhi.jpg',
        'yield': '≈2-5 kg/day',
      },
      {
        'title': 'Lakhimi',
        'description':
            'Compact, hardy draught breed from Ladakh; black coat; high-fat milk.',
        'image': 'assets/images/Lakhimi.jpg',
        'yield': '≈2-5 kg/day',
      },
      {
        'title': 'Malnad',
        'description':
            'Small, hardy draught breed from Karnataka; black coat; disease-resistant.',
        'image': 'assets/images/Malnad.jpg',
        'yield': '≈1.6L/day',
      },
      {
        'title': 'Malvi',
        'description':
            'Hardy draught breed from Madhya Pradesh; white-grey coat; strong.',
        'image': 'assets/images/Malvi.jpg',
        'yield': '≈916 kg/lactation',
      },
      {
        'title': 'Mewati',
        'description':
            'Hardy dual-purpose breed from Haryana, Rajasthan, and Uttar Pradesh.',
        'image': 'assets/images/Mewati.jpg',
        'yield': '≈958 kg/lactation',
      },
      {
        'title': 'Motu',
        'description':
            'Small, hardy draught breed from Odisha; reddish-brown coat; polled.',
        'image': 'assets/images/Motu.jpg',
        'yield': '≈100-140 kg/lactation',
      },
      {
        'title': 'Nagori',
        'description':
            'Hardy Rajasthan cattle for milk production and agricultural work.',
        'image': 'assets/images/Nagori.jpg',
        'yield': '8-12L/day',
      },
      {
        'title': 'Nari',
        'description':
            'Small draught breed from Madhya Pradesh; hardy; light brown coat.',
        'image': 'assets/images/Nari.jpg',
        'yield': '≈250-400 kg/lactation',
      },
      {
        'title': 'Nimari',
        'description':
            'Adaptable draught and milch cattle from Nimar, Madhya Pradesh.',
        'image': 'assets/images/Nimari.jpg',
        'yield': '6-9L/day',
      },
      {
        'title': 'Ongole',
        'description':
            'Large, muscular breed from Andhra Pradesh; heat-resistant; prized globally.',
        'image': 'assets/images/Ongole.jpg',
        'yield': '≈850-2,518 kg/lactation',
      },
      {
        'title': 'Poda Thurpu',
        'description':
            'Hardy draught breed from Telangana; spotted coat; drought-tolerant.',
        'image': 'assets/images/Poda Thurpu.jpg',
        'yield': '≈494-646 kg/lactation',
      },
      {
        'title': 'Ponwar',
        'description':
            'Hardy draught breed from Uttar Pradesh; black-and-white coat; active.',
        'image': 'assets/images/Ponwar.jpg',
        'yield': '≈460 kg/lactation',
      },
      {
        'title': 'Pulikulam',
        'description':
            'Hardy draught and game breed from Tamil Nadu; grey/white coat.',
        'image': 'assets/images/Pulikulam.jpg',
        'yield': '≈1.25 kg/day average',
      },
      {
        'title': 'Punganur',
        'description':
            'Compact, drought-resistant breed from Andhra Pradesh; prized for ghee.',
        'image': 'assets/images/Punganur.jpg',
        'yield': '≈467 kg/lactation (~2.7 kg peak/day)',
      },
      {
        'title': 'Purnea',
        'description':
            'Small-sized cattle from Bihar; hardy; utilized for milk and draught.',
        'image': 'assets/images/Purnea.jpg',
        'yield': '≈452-785 kg/lactation',
      },
      {
        'title': 'Rathi',
        'description':
            'Medium-sized dual-purpose breed from Rajasthan; good milk and draught.',
        'image': 'assets/images/Rathi.jpg',
        'yield': '≈1,500-1,800 kg/lactation',
      },
      {
        'title': 'Red Kandhari',
        'description':
            'Native Maharashtra breed; hardy, drought-resistant, suitable for milk and draught.',
        'image': 'assets/images/Red Kandhari.jpg',
        'yield': '≈1,800-2,000 kg/lactation',
      },
      {
        'title': 'Shweta Kapila',
        'description':
            'White-colored dual-purpose breed; good milk and draft capabilities.',
        'image': 'assets/images/Shweta Kapila.jpg',
        'yield': '≈1,800-2,200 kg/lactation',
      },
      {
        'title': 'Siri',
        'description':
            'Indigenous hill cattle of India, hardy, disease-resistant, low-maintenance.',
        'image': 'assets/images/Siri.jpg',
        'yield': '≈2-6 kg/day',
      },
      {
        'title': 'Tharparkar',
        'description':
            'Dual-purpose breed from Rajasthan; hardy, heat-tolerant, good draught ability.',
        'image': 'assets/images/Tharparkar.jpg',
        'yield': '≈8-10L/day',
      },
      {
        'title': 'Thutho',
        'description':
            'Indigenous small cattle, hardy, used for draught and milk.',
        'image': 'assets/images/Thutho.jpg',
        'yield': '≈1-3 kg/day',
      },
      {
        'title': 'Umblachery',
        'description':
            'Hardy Tamil Nadu breed, suitable for drought-prone areas; grey with white marks.',
        'image': 'assets/images/Umblachery.jpg',
        'yield': '≈2 kg/day',
      },
      {
        'title': 'Vechur',
        'description': 'Small Kerala breed, known for high-quality A2 milk.',
        'image': 'assets/images/Vechur.jpg',
        'yield': '≈3-4 kg/day',
      },
    ];
  }
}
