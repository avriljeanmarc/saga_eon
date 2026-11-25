import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SagaEonApp());
}

// ============================================================================
// LOCALIZATION (ENGLISH & FRENCH)
// ============================================================================

enum AppLang { en, fr }

class S {
  static String tr(AppLang lang, String en, String fr) => lang == AppLang.fr ? fr : en;

  static String genre(AppLang lang, String g) {
    if (lang == AppLang.en) return g;
    switch (g) {
      case 'All':
        return 'Tout';
      case 'Fantasy':
        return 'Fantaisie';
      case 'Supernatural':
        return 'Surnaturel';
      default:
        return g;
    }
  }
}

// ============================================================================
// DATA MODELS & CATALOG
// ============================================================================

enum ParticleTheme { embers, ash, rain, runes, stars }

enum EpisodeAccess { free, unlocked, timer, locked }

class StoryBeat {
  final double startSec;
  final double endSec;
  final String speakerEn;
  final String speakerFr;
  final String subtitleEn;
  final String subtitleFr;
  final Color tint;

  const StoryBeat({
    required this.startSec,
    required this.endSec,
    required this.speakerEn,
    required this.speakerFr,
    required this.subtitleEn,
    required this.subtitleFr,
    required this.tint,
  });
}

class SagaEpisode {
  final String id;
  final int number;
  final String titleEn;
  final String titleFr;
  final int durationSec;
  final EpisodeAccess access;
  final int coinCost;
  final int initialTimerSec;
  final int likes;
  final List<StoryBeat> beats;

  const SagaEpisode({
    required this.id,
    required this.number,
    required this.titleEn,
    required this.titleFr,
    required this.durationSec,
    required this.access,
    required this.coinCost,
    this.initialTimerSec = 0,
    required this.likes,
    required this.beats,
  });
}

class SagaComment {
  final String id;
  final String author;
  final int episodeNumber;
  final String timeAgoEn;
  final String timeAgoFr;
  final String textEn;
  final String textFr;

  const SagaComment({
    required this.id,
    required this.author,
    required this.episodeNumber,
    required this.timeAgoEn,
    required this.timeAgoFr,
    required this.textEn,
    required this.textFr,
  });
}

class SagaSeries {
  final String id;
  final int rank;
  final String title;
  final String taglineEn;
  final String taglineFr;
  final String synopsisEn;
  final String synopsisFr;
  final String genre;
  final String studio;
  final String rating;
  final int totalEpisodesCount;
  final String posterAsset;
  final String backdropAsset;
  final ParticleTheme particleTheme;
  final Color accentColor;
  final String scheduleEn;
  final String scheduleFr;
  final List<SagaEpisode> episodes;
  final List<SagaComment> initialComments;

  const SagaSeries({
    required this.id,
    required this.rank,
    required this.title,
    required this.taglineEn,
    required this.taglineFr,
    required this.synopsisEn,
    required this.synopsisFr,
    required this.genre,
    required this.studio,
    required this.rating,
    required this.totalEpisodesCount,
    required this.posterAsset,
    required this.backdropAsset,
    required this.particleTheme,
    required this.accentColor,
    required this.scheduleEn,
    required this.scheduleFr,
    required this.episodes,
    required this.initialComments,
  });
}

class WatchProgressEntry {
  final String sagaId;
  final int episodeNumber;
  final int progressSec;
  final DateTime updatedAt;

  const WatchProgressEntry({
    required this.sagaId,
    required this.episodeNumber,
    required this.progressSec,
    required this.updatedAt,
  });
}

List<SagaEpisode> _buildEpisodes({
  required String sagaId,
  required String sagaTitle,
  required String hero,
  required String rival,
  required Color tintA,
  required Color tintB,
  required List<(String, String)> titles,
}) {
  return List.generate(titles.length, (i) {
    final num = i + 1;
    final (titleEn, titleFr) = titles[i];
    final access = num <= 3
        ? EpisodeAccess.free
        : num == 4
            ? EpisodeAccess.timer
            : EpisodeAccess.locked;
    return SagaEpisode(
      id: '$sagaId-ep-$num',
      number: num,
      titleEn: titleEn,
      titleFr: titleFr,
      durationSec: 58,
      access: access,
      coinCost: num <= 8 ? 5 : 8,
      initialTimerSec: num == 4 ? 285 : 0,
      likes: 18400 - i * 920,
      beats: [
        StoryBeat(
          startSec: 0,
          endSec: 12,
          speakerEn: 'Narrator',
          speakerFr: 'Narrateur',
          subtitleEn: '$sagaTitle — Episode $num: $titleEn. The meridian bells toll past midnight.',
          subtitleFr: '$sagaTitle — Épisode $num : $titleFr. Les cloches du méridien sonnent passé minuit.',
          tint: tintA,
        ),
        StoryBeat(
          startSec: 12,
          endSec: 27,
          speakerEn: hero,
          speakerFr: hero,
          subtitleEn: 'Every second borrowed from the spire leaves a fracture across the lower district.',
          subtitleFr: 'Chaque seconde empruntée à la flèche laisse une fissure dans la ville basse.',
          tint: tintB,
        ),
        StoryBeat(
          startSec: 27,
          endSec: 43,
          speakerEn: rival,
          speakerFr: rival,
          subtitleEn: 'You still fight for a city that forgot your oath. Draw your steel.',
          subtitleFr: 'Tu te bats encore pour une cité qui a oublié ton serment. Dégaine ta lame.',
          tint: tintA,
        ),
        StoryBeat(
          startSec: 43,
          endSec: 58,
          speakerEn: hero,
          speakerFr: hero,
          subtitleEn: 'Then watch the pendulum stop. Zero Hour begins now.',
          subtitleFr: "Alors regarde le pendule s'arrêter. L'Heure Zéro commence maintenant.",
          tint: tintB,
        ),
      ],
    );
  });
}

final List<SagaSeries> kSagasCatalog = [
  SagaSeries(
    id: 'chrono-blade',
    rank: 1,
    title: 'Chrono Blade: Zero Hour',
    taglineEn: 'One borrowed minute. One shattered clocktower.',
    taglineFr: 'Une minute empruntée. Une tour brisée.',
    synopsisEn:
        'Exiled timekeeper Ren Vane wields an ember-forged katana capable of slicing sixty seconds out of fate.',
    synopsisFr:
        "Le gardien du temps exilé Ren Vane manie un katana forgé dans la braise, capable de trancher soixante secondes hors du destin.",
    genre: 'Action',
    studio: 'Studio Nocturne',
    rating: '4.9',
    totalEpisodesCount: 142,
    posterAsset: 'assets/images/poster_chrono_blade.jpg',
    backdropAsset: 'assets/images/hero_chrono_blade.jpg',
    particleTheme: ParticleTheme.embers,
    accentColor: const Color(0xFFF43F5E),
    scheduleEn: 'Daily 20:00',
    scheduleFr: 'Tous les jours 20h00',
    episodes: _buildEpisodes(
      sagaId: 'chrono-blade',
      sagaTitle: 'Chrono Blade',
      hero: 'Ren Vane',
      rival: 'Marshal Kael',
      tintA: const Color.fromRGBO(244, 63, 94, 0.22),
      tintB: const Color.fromRGBO(245, 158, 11, 0.18),
      titles: const [
        ('The Broken Escapement', "L'Échappement Brisé"),
        ('Sixty Borrowed Seconds', 'Soixante Secondes Empruntées'),
        ('Embers Over Ward Seven', 'Braises sur le Secteur Sept'),
        ('Oath of the Brass Spire', 'Serment de la Flèche de Cuivre'),
        ('Shadow of the Second Hand', "L'Ombre de la Trotteuse"),
        ('Duel on Rain-Slick Slate', "Duel sur l'Ardoise Mouillée"),
        ('The Clockmaker Ledger', "Le Registre de l'Horloger"),
        ('Fractured Horizon', 'Horizon Fracturé'),
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c1',
        author: 'Kuroda_M',
        episodeNumber: 1,
        timeAgoEn: '14m ago',
        timeAgoFr: 'il y a 14 min',
        textEn: 'That clocktower opening frame hits hard in vertical full screen.',
        textFr: "L'ouverture sur le beffroi claque vraiment en plein écran vertical.",
      ),
    ],
  ),
  SagaSeries(
    id: 'ashen-crown',
    rank: 2,
    title: 'Ashen Crown',
    taglineEn: 'Beneath the eclipse, only iron remembers.',
    taglineFr: "Sous l'éclipse, seul le fer se souvient.",
    synopsisEn:
        'Betrayed on the eve of her coronation, Empress Seraphina returns from the cinder wastes with twin obsidian blades.',
    synopsisFr:
        "Trahie la veille de son couronnement, l'impératrice Seraphina revient des terres de cendre avec deux lames d'obsidienne.",
    genre: 'Fantasy',
    studio: 'Iron Spire Studio',
    rating: '4.8',
    totalEpisodesCount: 118,
    posterAsset: 'assets/images/poster_ashen_crown.jpg',
    backdropAsset: 'assets/images/poster_ashen_crown.jpg',
    particleTheme: ParticleTheme.ash,
    accentColor: const Color(0xFFEF4444),
    scheduleEn: 'Mon · Wed · Fri',
    scheduleFr: 'Lun · Mer · Ven',
    episodes: _buildEpisodes(
      sagaId: 'ashen-crown',
      sagaTitle: 'Ashen Crown',
      hero: 'Seraphina',
      rival: 'Lord Vaelen',
      tintA: const Color.fromRGBO(239, 68, 68, 0.22),
      tintB: const Color.fromRGBO(251, 146, 60, 0.16),
      titles: const [
        ('Cinders of the First Throne', 'Cendres du Premier Trône'),
        ('Twin Blades in Ash', 'Lames Jumelles dans la Cendre'),
        ('Gate of the Fallen Guard', 'Porte de la Garde Déchue'),
        ('Blood Eclipse Rising', "L'Éclipse de Sang se Lève"),
        ('The Regent Confession', 'La Confession du Régent'),
        ('Siege of Marble Bridge', 'Siège du Pont de Marbre'),
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c4',
        author: 'Mira_K',
        episodeNumber: 1,
        timeAgoEn: '28m ago',
        timeAgoFr: 'il y a 28 min',
        textEn: 'Seraphina armor design under the eclipse is incredible.',
        textFr: "Le design de l'armure de Seraphina sous l'éclipse est magnifique.",
      ),
    ],
  ),
  SagaSeries(
    id: 'rain-shogun',
    rank: 3,
    title: 'Rain Shogun: Sector 9',
    taglineEn: 'Steel never rusts in neon rain.',
    taglineFr: "L'acier ne rouille jamais sous la pluie néon.",
    synopsisEn:
        'In a flooded vertical metropolis ruled by algorithmic syndicates, a rogue courier guards the last unencrypted human memory.',
    synopsisFr:
        'Dans une métropole verticale inondée dominée par des syndicats algorithmiques, un coursier rebelle protège le dernier souvenir humain.',
    genre: 'Sci-Fi',
    studio: 'Kaze Works',
    rating: '4.9',
    totalEpisodesCount: 96,
    posterAsset: 'assets/images/poster_neon_shogun.jpg',
    backdropAsset: 'assets/images/poster_neon_shogun.jpg',
    particleTheme: ParticleTheme.rain,
    accentColor: const Color(0xFFF59E0B),
    scheduleEn: 'Tue · Thu · Sat',
    scheduleFr: 'Mar · Jeu · Sam',
    episodes: _buildEpisodes(
      sagaId: 'rain-shogun',
      sagaTitle: 'Rain Shogun',
      hero: 'Kenji-09',
      rival: 'Director Sato',
      tintA: const Color.fromRGBO(245, 158, 11, 0.18),
      tintB: const Color.fromRGBO(56, 189, 248, 0.16),
      titles: const [
        ('Lanterns in Sector Nine', 'Lanternes du Secteur Neuf'),
        ('Static Under the Bridge', 'Parasites Sous le Pont'),
        ('The Analog Visor', 'Le Viseur Analogique'),
        ('Midnight Monorail', 'Monorail de Minuit'),
        ('Ghost Frequency', 'Fréquence Fantôme'),
      ],
    ),
    initialComments: const [],
  ),
  SagaSeries(
    id: 'eclipse-pact',
    rank: 4,
    title: 'The Eclipse Pact',
    taglineEn: 'Every shadow answers to the blood moon.',
    taglineFr: 'Chaque ombre répond à la lune de sang.',
    synopsisEn:
        'Archivist Julian Thorne unlocks a forbidden celestial astrolabe that binds twin spirit wolves to his bloodline.',
    synopsisFr:
        "L'archiviste Julian Thorne déverrouille un astrolabe céleste interdit qui lie deux loups spectraux à sa lignée.",
    genre: 'Supernatural',
    studio: 'Moonwell Animation',
    rating: '4.7',
    totalEpisodesCount: 108,
    posterAsset: 'assets/images/poster_eclipse_pact.jpg',
    backdropAsset: 'assets/images/poster_eclipse_pact.jpg',
    particleTheme: ParticleTheme.runes,
    accentColor: const Color(0xFFFB7185),
    scheduleEn: 'Daily 22:00',
    scheduleFr: 'Tous les jours 22h00',
    episodes: _buildEpisodes(
      sagaId: 'eclipse-pact',
      sagaTitle: 'The Eclipse Pact',
      hero: 'Julian Thorne',
      rival: 'Elder Morwen',
      tintA: const Color.fromRGBO(251, 113, 133, 0.20),
      tintB: const Color.fromRGBO(250, 204, 21, 0.15),
      titles: const [
        ('The Golden Astrolabe', "L'Astrolabe d'Or"),
        ('Wolves of the Pine Mist', 'Loups de la Brume'),
        ('Crimson Moon Ascending', 'Ascension de la Lune Pourpre'),
        ('Ward of Silver Ash', "Sceau de Cendre d'Argent"),
      ],
    ),
    initialComments: const [],
  ),
  SagaSeries(
    id: 'velvet-orbit',
    rank: 5,
    title: 'Velvet Orbit',
    taglineEn: 'Two rival heirs above a dying ring.',
    taglineFr: "Deux héritiers rivaux au-dessus d'un anneau mourant.",
    synopsisEn:
        'Assigned to co-command an orbital conservatory around Saturn rings, rival pilots uncover a conspiracy.',
    synopsisFr:
        "Chargés de co-diriger une station serre orbitale autour des anneaux de Saturne, deux pilotes rivaux découvrent un complot.",
    genre: 'Romance',
    studio: 'Atelier Celestia',
    rating: '4.8',
    totalEpisodesCount: 84,
    posterAsset: 'assets/images/poster_velvet_orbit.jpg',
    backdropAsset: 'assets/images/poster_velvet_orbit.jpg',
    particleTheme: ParticleTheme.stars,
    accentColor: const Color(0xFFFBBF24),
    scheduleEn: 'Fri · Sun',
    scheduleFr: 'Ven · Dim',
    episodes: _buildEpisodes(
      sagaId: 'velvet-orbit',
      sagaTitle: 'Velvet Orbit',
      hero: 'Claire Vance',
      rival: 'Leo Sterling',
      tintA: const Color.fromRGBO(251, 191, 36, 0.18),
      tintB: const Color.fromRGBO(99, 102, 241, 0.20),
      titles: const [
        ('Conservatory in Orbit', 'Verrière en Orbite'),
        ('The Ringed Horizon', "L'Horizon aux Anneaux"),
        ('Lanterns Under Glass', 'Lanternes Sous Verre'),
        ('Zero-Gravity Waltz', 'Valse en Apesanteur'),
      ],
    ),
    initialComments: const [],
  ),
];

// ============================================================================
// APP STATE CONTROLLER
// ============================================================================

class SagaAppState extends ChangeNotifier {
  AppLang lang = AppLang.en;
  int coins = 30;
  bool dailyClaimed = false;
  final Set<String> unlockedIds = {};
  final Set<String> bookmarkedIds = {'chrono-blade', 'velvet-orbit'};
  final Set<String> likedEpisodeIds = {};
  final Map<String, WatchProgressEntry> watchProgress = {
    'chrono-blade': WatchProgressEntry(
      sagaId: 'chrono-blade',
      episodeNumber: 1,
      progressSec: 18,
      updatedAt: DateTime.now(),
    ),
  };
  final Map<String, List<SagaComment>> customComments = {};
  final Map<String, int> timerRemaining = {};
  Timer? _countdownTimer;

  SagaAppState() {
    for (final s in kSagasCatalog) {
      for (final ep in s.episodes) {
        if (ep.access == EpisodeAccess.timer && ep.initialTimerSec > 0) {
          timerRemaining[ep.id] = ep.initialTimerSec;
        }
      }
    }
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      bool changed = false;
      for (final key in timerRemaining.keys) {
        final v = timerRemaining[key] ?? 0;
        if (v > 0) {
          timerRemaining[key] = v - 1;
          changed = true;
        }
      }
      if (changed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void setLang(AppLang next) {
    if (lang == next) return;
    lang = next;
    notifyListeners();
  }

  bool isEpisodePlayable(SagaEpisode ep) {
    if (ep.access == EpisodeAccess.free || ep.access == EpisodeAccess.unlocked) return true;
    if (unlockedIds.contains(ep.id)) return true;
    if (ep.access == EpisodeAccess.timer && (timerRemaining[ep.id] ?? 1) <= 0) return true;
    return false;
  }

  bool unlockEpisode(SagaEpisode ep) {
    if (isEpisodePlayable(ep)) return true;
    if (coins < ep.coinCost) return false;
    coins -= ep.coinCost;
    unlockedIds.add(ep.id);
    notifyListeners();
    return true;
  }

  void toggleBookmark(String sagaId) {
    if (bookmarkedIds.contains(sagaId)) {
      bookmarkedIds.remove(sagaId);
    } else {
      bookmarkedIds.add(sagaId);
    }
    notifyListeners();
  }

  void toggleLike(String episodeId) {
    if (likedEpisodeIds.contains(episodeId)) {
      likedEpisodeIds.remove(episodeId);
    } else {
      likedEpisodeIds.add(episodeId);
    }
    notifyListeners();
  }

  void addComment(String sagaId, int epNum, String text) {
    final list = customComments.putIfAbsent(sagaId, () => []);
    list.insert(
      0,
      SagaComment(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        author: lang == AppLang.fr ? 'Vous' : 'You',
        episodeNumber: epNum,
        timeAgoEn: 'Just now',
        timeAgoFr: "À l'instant",
        textEn: text,
        textFr: text,
      ),
    );
    notifyListeners();
  }

  List<SagaComment> commentsFor(SagaSeries saga) {
    return [...(customComments[saga.id] ?? const []), ...saga.initialComments];
  }

  void updateProgress(String sagaId, int episodeNumber, int sec) {
    watchProgress[sagaId] = WatchProgressEntry(
      sagaId: sagaId,
      episodeNumber: episodeNumber,
      progressSec: sec,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void claimDaily() {
    if (dailyClaimed) return;
    dailyClaimed = true;
    coins += 20;
    notifyListeners();
  }

  void addCoins(int amount) {
    coins += amount;
    notifyListeners();
  }
}

// ============================================================================
// ROOT APP & NAVIGATION SHELL
// ============================================================================

class SagaEonApp extends StatefulWidget {
  const SagaEonApp({super.key});

  @override
  State<SagaEonApp> createState() => _SagaEonAppState();
}

class _SagaEonAppState extends State<SagaEonApp> {
  final SagaAppState _state = SagaAppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saga Eon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0C10),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF43F5E),
          secondary: Color(0xFFF59E0B),
          surface: Color(0xFF14161D),
        ),
      ),
      home: SagaEonShell(appState: _state),
    );
  }
}

class SagaEonShell extends StatefulWidget {
  final SagaAppState appState;
  const SagaEonShell({super.key, required this.appState});

  @override
  State<SagaEonShell> createState() => _SagaEonShellState();
}

class _SagaEonShellState extends State<SagaEonShell> {
  int _tabIndex = 0;
  String _activeSagaId = 'chrono-blade';
  int _activeEpisodeNumber = 1;

  void _playEpisode(String sagaId, int episodeNumber) {
    setState(() {
      _activeSagaId = sagaId;
      _activeEpisodeNumber = episodeNumber;
      _tabIndex = 1;
    });
  }

  void _openSagaDetail(SagaSeries saga) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SagaDetailScreen(
          saga: saga,
          appState: widget.appState,
          onPlayEpisode: (epNum) {
            Navigator.of(context).pop();
            _playEpisode(saga.id, epNum);
          },
          onGoToCoins: () {
            Navigator.of(context).pop();
            setState(() => _tabIndex = 3);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final lang = widget.appState.lang;
        final activeSaga = kSagasCatalog.firstWhere(
          (s) => s.id == _activeSagaId,
          orElse: () => kSagasCatalog.first,
        );

        final screens = [
          DiscoverScreen(
            appState: widget.appState,
            onOpenSaga: _openSagaDetail,
            onPlayEpisode: _playEpisode,
            onGoToCoins: () => setState(() => _tabIndex = 3),
          ),
          VerticalSagaPlayerScreen(
            key: ValueKey('$_activeSagaId-$_activeEpisodeNumber'),
            saga: activeSaga,
            initialEpisodeNumber: _activeEpisodeNumber,
            appState: widget.appState,
            onBackToDetail: () => _openSagaDetail(activeSaga),
            onGoToCoins: () => setState(() => _tabIndex = 3),
          ),
          LibraryScreen(
            appState: widget.appState,
            onOpenSaga: _openSagaDetail,
            onPlayEpisode: _playEpisode,
            onBrowseDiscover: () => setState(() => _tabIndex = 0),
          ),
          CoinsWalletScreen(appState: widget.appState),
        ];

        return Scaffold(
          body: SafeArea(child: screens[_tabIndex]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabIndex,
            onTap: (index) => setState(() => _tabIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF101218),
            selectedItemColor: const Color(0xFFF43F5E),
            unselectedItemColor: Colors.white54,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.explore), label: S.tr(lang, 'Discover', 'Découvrir')),
              BottomNavigationBarItem(icon: const Icon(Icons.play_circle_fill), label: S.tr(lang, 'Watch', 'Regarder')),
              BottomNavigationBarItem(icon: const Icon(Icons.bookmark), label: S.tr(lang, 'My List', 'Ma Liste')),
              BottomNavigationBarItem(icon: const Icon(Icons.monetization_on), label: S.tr(lang, 'Coins', 'Pièces')),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// ARTWORK RENDERER
// ============================================================================

class SagaPosterArt extends StatelessWidget {
  final SagaSeries saga;
  final bool useBackdrop;
  const SagaPosterArt({super.key, required this.saga, this.useBackdrop = false});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            saga.accentColor.withAlpha(90),
            const Color(0xFF1A1D28),
            const Color(0xFF0B0C10),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _AtmosphericPainter(
          theme: saga.particleTheme,
          accent: saga.accentColor,
          progress: 0.35,
        ),
      ),
    );

    return fallback;
  }
}

// ============================================================================
// SCREEN 1: DISCOVER FEED
// ============================================================================

class DiscoverScreen extends StatefulWidget {
  final SagaAppState appState;
  final void Function(SagaSeries) onOpenSaga;
  final void Function(String sagaId, int epNum) onPlayEpisode;
  final VoidCallback onGoToCoins;

  const DiscoverScreen({
    super.key,
    required this.appState,
    required this.onOpenSaga,
    required this.onPlayEpisode,
    required this.onGoToCoins,
  });

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedGenre = 'All';
  String _searchQuery = '';
  final _genres = const ['All', 'Action', 'Fantasy', 'Sci-Fi', 'Supernatural', 'Romance'];

  @override
  Widget build(BuildContext context) {
    final lang = widget.appState.lang;
    final featured = kSagasCatalog.first;
    final filtered = kSagasCatalog.where((s) {
      final matchesGenre = _selectedGenre == 'All' || s.genre == _selectedGenre;
      final q = _searchQuery.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          s.title.toLowerCase().contains(q) ||
          s.studio.toLowerCase().contains(q) ||
          s.genre.toLowerCase().contains(q);
      return matchesGenre && matchesSearch;
    }).toList();

    final continueEntries = widget.appState.watchProgress.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Saga Eon',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => widget.appState.setLang(lang == AppLang.en ? AppLang.fr : AppLang.en),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF14161D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(44, 36),
                  ),
                  child: Text(lang == AppLang.en ? 'EN' : 'FR', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: widget.onGoToCoins,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, size: 18, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.appState.coins}',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFFBBF24)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Featured Hero Banner
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 290,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SagaPosterArt(saga: featured, useBackdrop: true),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color.fromRGBO(11, 12, 16, 0.7), Color(0xFF0B0C10)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${S.tr(lang, 'Featured', 'À la une')} · ${S.genre(lang, featured.genre)} · ${featured.totalEpisodesCount} ${S.tr(lang, 'Episodes', 'Épisodes')}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(featured.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.15)),
                      const SizedBox(height: 6),
                      Text(
                        lang == AppLang.fr ? featured.taglineFr : featured.taglineEn,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () => widget.onPlayEpisode(featured.id, 1),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: Text(S.tr(lang, 'Watch Ep. 1', "Voir Ép. 1")),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF43F5E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () => widget.onOpenSaga(featured),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(S.tr(lang, 'Episodes', 'Épisodes')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Search Field
        TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: S.tr(lang, 'Search sagas or studios...', 'Rechercher une saga ou un studio...'),
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
            filled: true,
            fillColor: const Color(0xFF14161D),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Genre Filter Bar
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _genres.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final g = _genres[i];
              final active = g == _selectedGenre;
              return GestureDetector(
                onTap: () => setState(() => _selectedGenre = g),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFF43F5E) : const Color(0xFF14161D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: active ? Colors.transparent : Colors.white12),
                  ),
                  child: Text(
                    S.genre(lang, g),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : Colors.white70),
                  ),
                ),
              );
            },
          ),
        ),

        if (continueEntries.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(S.tr(lang, 'Continue Watching', 'Reprendre la lecture'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...continueEntries.map((entry) {
            final saga = kSagasCatalog.firstWhere((s) => s.id == entry.sagaId);
            final ep = saga.episodes.firstWhere((e) => e.number == entry.episodeNumber);
            final ratio = (entry.progressSec / ep.durationSec).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => widget.onPlayEpisode(saga.id, ep.number),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14161D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(width: 54, height: 72, child: SagaPosterArt(saga: saga)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(saga.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                              '${S.tr(lang, 'Ep.', 'Ép.')} ${ep.number} · ${lang == AppLang.fr ? ep.titleFr : ep.titleEn}',
                              style: const TextStyle(color: Colors.white60, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 4,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation(Color(0xFFF43F5E)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.play_circle_filled, color: Color(0xFFF43F5E), size: 30),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],

        const SizedBox(height: 24),
        Text(S.tr(lang, 'Top Ranked Sagas', 'Sagas les mieux classées'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kSagasCatalog.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final saga = kSagasCatalog[index];
              return GestureDetector(
                onTap: () => widget.onOpenSaga(saga),
                child: SizedBox(
                  width: 148,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              SagaPosterArt(saga: saga),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.85)],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 8,
                                child: Text(saga.rank.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(saga.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('${S.genre(lang, saga.genre)} · ${saga.totalEpisodesCount} ${S.tr(lang, 'Ep', 'Ép')}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
        Text(
          _selectedGenre == 'All'
              ? S.tr(lang, 'All Vertical Sagas', 'Toutes les sagas verticales')
              : '${S.tr(lang, 'Sagas', 'Sagas')} · ${S.genre(lang, _selectedGenre)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Center(child: Text(S.tr(lang, 'No sagas matched your search.', 'Aucune saga trouvée.'), style: const TextStyle(color: Colors.white54))),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.64,
            ),
            itemBuilder: (_, i) {
              final saga = filtered[i];
              return GestureDetector(
                onTap: () => widget.onOpenSaga(saga),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF14161D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: SagaPosterArt(saga: saga)),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(saga.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 3),
                            Text(
                              '${S.genre(lang, saga.genre)} · ${saga.totalEpisodesCount} ${S.tr(lang, 'Ep', 'Ép')} · ${saga.rating}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

// ============================================================================
// SCREEN 2: SAGA DETAIL & EPISODE PROGRESSION
// ============================================================================

class SagaDetailScreen extends StatefulWidget {
  final SagaSeries saga;
  final SagaAppState appState;
  final void Function(int episodeNumber) onPlayEpisode;
  final VoidCallback onGoToCoins;

  const SagaDetailScreen({
    super.key,
    required this.saga,
    required this.appState,
    required this.onPlayEpisode,
    required this.onGoToCoins,
  });

  @override
  State<SagaDetailScreen> createState() => _SagaDetailScreenState();
}

class _SagaDetailScreenState extends State<SagaDetailScreen> {
  bool _unlockedOnly = false;

  String _formatTimer(int totalSec) {
    final s = math.max(0, totalSec);
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final rem = (s % 60).toString().padLeft(2, '0');
    return '$m:$rem';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final lang = widget.appState.lang;
        final isSaved = widget.appState.bookmarkedIds.contains(widget.saga.id);
        final lastEp = widget.appState.watchProgress[widget.saga.id]?.episodeNumber;
        final episodes = _unlockedOnly
            ? widget.saga.episodes.where(widget.appState.isEpisodePlayable).toList()
            : widget.saga.episodes;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B0C10),
            elevation: 0,
            title: Text(widget.saga.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            actions: [
              IconButton(
                onPressed: () => widget.appState.toggleBookmark(widget.saga.id),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? const Color(0xFFFBBF24) : Colors.white,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(width: 118, height: 158, child: SagaPosterArt(saga: widget.saga)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.genre(lang, widget.saga.genre)} · ${widget.saga.totalEpisodesCount} ${S.tr(lang, 'Ep', 'Ép')} · ${widget.saga.rating}',
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(widget.saga.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.saga.studio} · ${lang == AppLang.fr ? widget.saga.scheduleFr : widget.saga.scheduleEn}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => widget.onPlayEpisode(lastEp ?? 1),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: Text(lastEp != null ? '${S.tr(lang, 'Resume Ep.', 'Reprendre Ép.')} $lastEp' : S.tr(lang, 'Watch Ep. 1', 'Voir Ép. 1')),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF43F5E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(lang == AppLang.fr ? widget.saga.synopsisFr : widget.saga.synopsisEn, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.tr(lang, 'Episodes', 'Épisodes'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(value: false, label: Text(S.tr(lang, 'All', 'Tous'))),
                      ButtonSegment(value: true, label: Text(S.tr(lang, 'Unlocked', 'Débloqués'))),
                    ],
                    selected: {_unlockedOnly},
                    onSelectionChanged: (v) => setState(() => _unlockedOnly = v.first),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...episodes.map((ep) {
                final playable = widget.appState.isEpisodePlayable(ep);
                final timerSec = widget.appState.timerRemaining[ep.id] ?? 0;
                final isTimer = !playable && ep.access == EpisodeAccess.timer && timerSec > 0;
                final epTitle = lang == AppLang.fr ? ep.titleFr : ep.titleEn;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14161D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListTile(
                    onTap: () => widget.onPlayEpisode(ep.number),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0B0C10),
                      child: Text(ep.number.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                    title: Text(epTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      playable
                          ? '0:${ep.durationSec} · ${ep.access == EpisodeAccess.free ? S.tr(lang, 'Free', 'Gratuit') : S.tr(lang, 'Unlocked', 'Débloqué')}'
                          : isTimer
                              ? '0:${ep.durationSec} · ${S.tr(lang, 'Free in', 'Gratuit dans')} ${_formatTimer(timerSec)}'
                              : '0:${ep.durationSec} · ${ep.coinCost} ${S.tr(lang, 'Coins', 'Pièces')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: playable ? const Color(0xFF34D399) : isTimer ? const Color(0xFFFBBF24) : Colors.white54,
                      ),
                    ),
                    trailing: playable
                        ? Text(S.tr(lang, 'Watch', 'Voir'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                        : widget.appState.coins >= ep.coinCost
                            ? TextButton(
                                onPressed: () {
                                  if (widget.appState.unlockEpisode(ep)) {
                                    widget.onPlayEpisode(ep.number);
                                  }
                                },
                                child: Text('${S.tr(lang, 'Unlock', 'Débloquer')} ${ep.coinCost}c', style: const TextStyle(color: Color(0xFFF43F5E))),
                              )
                            : TextButton(
                                onPressed: widget.onGoToCoins,
                                child: Text(S.tr(lang, 'Get Coins', 'Obtenir'), style: const TextStyle(color: Color(0xFFFBBF24))),
                              ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// SCREEN 3: VERTICAL 9:16 SAGA PLAYER
// ============================================================================

class VerticalSagaPlayerScreen extends StatefulWidget {
  final SagaSeries saga;
  final int initialEpisodeNumber;
  final SagaAppState appState;
  final VoidCallback onBackToDetail;
  final VoidCallback onGoToCoins;

  const VerticalSagaPlayerScreen({
    super.key,
    required this.saga,
    required this.initialEpisodeNumber,
    required this.appState,
    required this.onBackToDetail,
    required this.onGoToCoins,
  });

  @override
  State<VerticalSagaPlayerScreen> createState() => _VerticalSagaPlayerScreenState();
}

class _VerticalSagaPlayerScreenState extends State<VerticalSagaPlayerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget.initialEpisodeNumber - 1).clamp(0, widget.saga.episodes.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _jumpToEpisode(int episodeNumber) {
    final idx = (episodeNumber - 1).clamp(0, widget.saga.episodes.length - 1);
    _pageController.animateToPage(idx, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.saga.episodes.length,
      onPageChanged: (idx) => setState(() => _currentIndex = idx),
      itemBuilder: (context, idx) {
        final ep = widget.saga.episodes[idx];
        return _EpisodeVerticalFrame(
          saga: widget.saga,
          episode: ep,
          isActive: idx == _currentIndex,
          appState: widget.appState,
          onBack: widget.onBackToDetail,
          onSelectEpisode: _jumpToEpisode,
          onGoToCoins: widget.onGoToCoins,
        );
      },
    );
  }
}

class _EpisodeVerticalFrame extends StatefulWidget {
  final SagaSeries saga;
  final SagaEpisode episode;
  final bool isActive;
  final SagaAppState appState;
  final VoidCallback onBack;
  final void Function(int epNum) onSelectEpisode;
  final VoidCallback onGoToCoins;

  const _EpisodeVerticalFrame({
    required this.saga,
    required this.episode,
    required this.isActive,
    required this.appState,
    required this.onBack,
    required this.onSelectEpisode,
    required this.onGoToCoins,
  });

  @override
  State<_EpisodeVerticalFrame> createState() => _EpisodeVerticalFrameState();
}

class _EpisodeVerticalFrameState extends State<_EpisodeVerticalFrame> {
  double _currentSec = 0;
  bool _isPlaying = true;
  double _speed = 1.0;
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void didUpdateWidget(covariant _EpisodeVerticalFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _isPlaying = widget.isActive;
    }
  }

  void _startTicker() {
    _tickTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (!mounted || !widget.isActive || !_isPlaying) return;
      if (!widget.appState.isEpisodePlayable(widget.episode)) return;
      setState(() {
        _currentSec += 0.15 * _speed;
        if (_currentSec >= widget.episode.durationSec) {
          _currentSec = 0;
          if (widget.episode.number < widget.saga.episodes.length) {
            widget.onSelectEpisode(widget.episode.number + 1);
          }
        }
      });
      if (_currentSec.floor() % 2 == 0) {
        widget.appState.updateProgress(widget.saga.id, widget.episode.number, _currentSec.floor());
      }
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  StoryBeat get _currentBeat {
    for (final b in widget.episode.beats) {
      if (_currentSec >= b.startSec && _currentSec < b.endSec) return b;
    }
    return widget.episode.beats.last;
  }

  String _clock(double sec) {
    final s = sec.floor().clamp(0, 3599);
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  void _openCommentsSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF14161D),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return AnimatedBuilder(
          animation: widget.appState,
          builder: (_, __) {
            final lang = widget.appState.lang;
            final comments = widget.appState.commentsFor(widget.saga);
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.62,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${S.tr(lang, 'Comments', 'Commentaires')} (${comments.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white12),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: comments.length,
                        itemBuilder: (_, i) {
                          final c = comments[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${c.author} · ${S.tr(lang, 'Ep.', 'Ép.')} ${c.episodeNumber} · ${lang == AppLang.fr ? c.timeAgoFr : c.timeAgoEn}',
                                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                                ),
                                const SizedBox(height: 4),
                                Text(lang == AppLang.fr ? c.textFr : c.textEn, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: S.tr(lang, 'Add a comment...', 'Ajouter un commentaire...'),
                                filled: true,
                                fillColor: const Color(0xFF0B0C10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              final txt = controller.text.trim();
                              if (txt.isEmpty) return;
                              widget.appState.addComment(widget.saga.id, widget.episode.number, txt);
                              controller.clear();
                            },
                            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
                            child: Text(S.tr(lang, 'Post', 'Publier')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openEpisodesSheet() {
    final lang = widget.appState.lang;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14161D),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.65,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.saga.title} · ${S.tr(lang, 'Episodes', 'Épisodes')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white12),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.saga.episodes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (_, i) {
                    final ep = widget.saga.episodes[i];
                    final playable = widget.appState.isEpisodePlayable(ep);
                    final isCurrent = ep.number == widget.episode.number;
                    final epTitle = lang == AppLang.fr ? ep.titleFr : ep.titleEn;
                    return ListTile(
                      onTap: () {
                        Navigator.pop(ctx);
                        widget.onSelectEpisode(ep.number);
                      },
                      title: Text(
                        '${ep.number.toString().padLeft(2, '0')} · $epTitle',
                        style: TextStyle(color: isCurrent ? const Color(0xFFF43F5E) : Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      trailing: Text(
                        playable
                            ? (isCurrent ? S.tr(lang, 'Playing', 'En cours') : S.tr(lang, 'Play', 'Lire'))
                            : '${ep.coinCost} ${S.tr(lang, 'Coins', 'Pièces')}',
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.appState.lang;
    final playable = widget.appState.isEpisodePlayable(widget.episode);
    final isLiked = widget.appState.likedEpisodeIds.contains(widget.episode.id);
    final isBookmarked = widget.appState.bookmarkedIds.contains(widget.saga.id);
    final commentsCount = widget.appState.commentsFor(widget.saga).length;
    final timerLeft = widget.appState.timerRemaining[widget.episode.id] ?? 0;
    final beat = _currentBeat;
    final scale = 1.0 + (_currentSec / widget.episode.durationSec) * 0.1;

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: playable ? scale : 1.04,
          child: SagaPosterArt(saga: widget.saga, useBackdrop: widget.episode.number.isEven),
        ),
        Container(color: beat.tint),
        IgnorePointer(
          child: CustomPaint(
            painter: _AtmosphericPainter(
              theme: widget.saga.particleTheme,
              accent: widget.saga.accentColor,
              progress: _currentSec / widget.episode.durationSec,
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(0, 0, 0, 0.7), Colors.transparent, Color.fromRGBO(0, 0, 0, 0.92)],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
        ),

        if (playable)
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: !_isPlaying
                  ? Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow, size: 34, color: Colors.white),
                    )
                  : null,
            ),
          ),

        // Top Bar
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.saga.title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      '${S.tr(lang, 'Ep.', 'Ép.')} ${widget.episode.number} · ${lang == AppLang.fr ? widget.episode.titleFr : widget.episode.titleEn}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => widget.appState.setLang(lang == AppLang.en ? AppLang.fr : AppLang.en),
                style: TextButton.styleFrom(backgroundColor: Colors.black45, foregroundColor: Colors.white),
                child: Text(lang == AppLang.en ? 'EN' : 'FR'),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => setState(() => _speed = _speed == 1.0 ? 1.5 : 1.0),
                style: TextButton.styleFrom(backgroundColor: Colors.black45, foregroundColor: Colors.white),
                child: Text('${_speed == 1.0 ? '1' : '1.5'}x'),
              ),
            ],
          ),
        ),

        // Right-Hand Engagement Rail
        Positioned(
          right: 10,
          bottom: 92,
          child: Column(
            children: [
              IconButton(
                onPressed: () => widget.appState.toggleLike(widget.episode.id),
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? const Color(0xFFF43F5E) : Colors.white, size: 28),
              ),
              Text('${((widget.episode.likes + (isLiked ? 1 : 0)) / 1000).toStringAsFixed(1)}K', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(onPressed: _openCommentsSheet, icon: const Icon(Icons.comment_outlined, size: 27)),
              Text('$commentsCount', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(
                onPressed: () => widget.appState.toggleBookmark(widget.saga.id),
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: isBookmarked ? const Color(0xFFFBBF24) : Colors.white, size: 28),
              ),
              Text(isBookmarked ? S.tr(lang, 'Saved', 'Enreg.') : S.tr(lang, 'Save', 'Enreg.'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(onPressed: _openEpisodesSheet, icon: const Icon(Icons.list_alt, size: 28)),
              Text(S.tr(lang, 'Episodes', 'Épisodes'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${widget.saga.title} - Ep ${widget.episode.number}'));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.tr(lang, 'Episode link copied', "Lien de l'épisode copié"))));
                },
                icon: const Icon(Icons.share_outlined, size: 25),
              ),
            ],
          ),
        ),

        if (playable)
          Positioned(
            left: 16,
            right: 72,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang == AppLang.fr ? beat.speakerFr : beat.speakerEn, style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(lang == AppLang.fr ? beat.subtitleFr : beat.subtitleEn, style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _isPlaying = !_isPlaying),
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: Slider(
                        value: _currentSec.clamp(0, widget.episode.durationSec.toDouble()),
                        max: widget.episode.durationSec.toDouble(),
                        activeColor: const Color(0xFFF43F5E),
                        inactiveColor: Colors.white24,
                        onChanged: (v) => setState(() => _currentSec = v),
                      ),
                    ),
                    Text('${_clock(_currentSec)} / ${_clock(widget.episode.durationSec.toDouble())}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 42, color: Color(0xFFFBBF24)),
                const SizedBox(height: 14),
                Text('${widget.saga.title} · ${S.tr(lang, 'Episode', 'Épisode')} ${widget.episode.number}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 6),
                Text(lang == AppLang.fr ? widget.episode.titleFr : widget.episode.titleEn, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  widget.episode.access == EpisodeAccess.timer && timerLeft > 0
                      ? '${S.tr(lang, 'Unlocks free in', 'Déblocage gratuit dans')} ${_clock(timerLeft.toDouble())}'
                      : S.tr(lang, 'Unlock this episode to continue watching.', 'Débloquez cet épisode pour continuer.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: 240,
                  child: widget.appState.coins >= widget.episode.coinCost
                      ? FilledButton.icon(
                          onPressed: () => widget.appState.unlockEpisode(widget.episode),
                          icon: const Icon(Icons.monetization_on, size: 18),
                          label: Text('${S.tr(lang, 'Unlock', 'Débloquer')} · ${widget.episode.coinCost} ${S.tr(lang, 'Coins', 'Pièces')}'),
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
                        )
                      : FilledButton.icon(
                          onPressed: widget.onGoToCoins,
                          icon: const Icon(Icons.monetization_on, size: 18),
                          label: Text('${S.tr(lang, 'Get Free Coins', 'Pièces gratuites')} (${widget.appState.coins})'),
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.black),
                        ),
                ),
                const SizedBox(height: 10),
                TextButton(onPressed: _openEpisodesSheet, child: Text(S.tr(lang, 'Browse Episodes', 'Parcourir les épisodes'))),
              ],
            ),
          ),
      ],
    );
  }
}

class _AtmosphericPainter extends CustomPainter {
  final ParticleTheme theme;
  final Color accent;
  final double progress;

  const _AtmosphericPainter({
    required this.theme,
    required this.accent,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 28; i++) {
      final seed = i * 137.5;
      final x = ((seed % 100) / 100.0) * size.width;
      final baseY = ((seed * 1.7) % 100) / 100.0;
      final y = theme == ParticleTheme.rain
          ? ((baseY + progress * 3.0) % 1.0) * size.height
          : ((baseY - progress * 0.8 + 1.0) % 1.0) * size.height;

      if (theme == ParticleTheme.rain) {
        paint
          ..color = Colors.lightBlueAccent.withAlpha(110)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(x, y), Offset(x - 3, y + 14), paint);
      } else {
        paint
          ..style = PaintingStyle.fill
          ..color = (theme == ParticleTheme.stars ? Colors.amberAccent : accent).withAlpha(140);
        canvas.drawCircle(Offset(x, y), (i % 3) + 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AtmosphericPainter oldDelegate) => oldDelegate.progress != progress;
}

// ============================================================================
// SCREEN 4: MY LIST & WATCH HISTORY
// ============================================================================

class LibraryScreen extends StatefulWidget {
  final SagaAppState appState;
  final void Function(SagaSeries) onOpenSaga;
  final void Function(String sagaId, int epNum) onPlayEpisode;
  final VoidCallback onBrowseDiscover;

  const LibraryScreen({
    super.key,
    required this.appState,
    required this.onOpenSaga,
    required this.onPlayEpisode,
    required this.onBrowseDiscover,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    final lang = widget.appState.lang;
    final saved = kSagasCatalog.where((s) => widget.appState.bookmarkedIds.contains(s.id)).toList();
    final history = widget.appState.watchProgress.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(S.tr(lang, 'My List', 'Ma Liste'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text('${S.tr(lang, 'Saved', 'Enregistrées')} (${saved.length})')),
            ButtonSegment(value: true, label: Text('${S.tr(lang, 'History', 'Historique')} (${history.length})')),
          ],
          selected: {_showHistory},
          onSelectionChanged: (v) => setState(() => _showHistory = v.first),
        ),
        const SizedBox(height: 18),
        if (!_showHistory)
          if (saved.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Text(S.tr(lang, 'Your watchlist is empty.', 'Votre liste est vide.'), style: const TextStyle(color: Colors.white60)),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: widget.onBrowseDiscover, child: Text(S.tr(lang, 'Browse Sagas', 'Parcourir les sagas'))),
                  ],
                ),
              ),
            )
          else
            ...saved.map((saga) {
              final resumeEp = widget.appState.watchProgress[saga.id]?.episodeNumber ?? 1;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF14161D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => widget.onOpenSaga(saga),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(width: 66, height: 88, child: SagaPosterArt(saga: saga)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(saga.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('${S.genre(lang, saga.genre)} · ${saga.totalEpisodesCount} ${S.tr(lang, 'Ep', 'Ép')}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FilledButton.icon(
                                onPressed: () => widget.onPlayEpisode(saga.id, resumeEp),
                                icon: const Icon(Icons.play_arrow, size: 16),
                                label: Text('${S.tr(lang, 'Watch Ep.', 'Voir Ép.')} $resumeEp'),
                                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E), padding: const EdgeInsets.symmetric(horizontal: 12)),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => widget.appState.toggleBookmark(saga.id),
                                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
        else
          ...history.map((entry) {
            final saga = kSagasCatalog.firstWhere((s) => s.id == entry.sagaId);
            final ep = saga.episodes.firstWhere((e) => e.number == entry.episodeNumber);
            return ListTile(
              onTap: () => widget.onPlayEpisode(saga.id, ep.number),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(width: 44, height: 58, child: SagaPosterArt(saga: saga)),
              ),
              title: Text(saga.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${S.tr(lang, 'Ep.', 'Ép.')} ${ep.number} · ${lang == AppLang.fr ? ep.titleFr : ep.titleEn}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: const Icon(Icons.play_arrow, color: Color(0xFFF43F5E)),
            );
          }),
      ],
    );
  }
}

// ============================================================================
// SCREEN 5: EON COINS WALLET & LANGUAGE PREFERENCE
// ============================================================================

class CoinsWalletScreen extends StatefulWidget {
  final SagaAppState appState;
  const CoinsWalletScreen({super.key, required this.appState});

  @override
  State<CoinsWalletScreen> createState() => _CoinsWalletScreenState();
}

class _CoinsWalletScreenState extends State<CoinsWalletScreen> {
  int? _adCountdown;
  Timer? _adTimer;

  void _startPreviewAd() {
    if (_adCountdown != null) return;
    setState(() => _adCountdown = 5);
    _adTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if ((_adCountdown ?? 0) <= 1) {
        t.cancel();
        setState(() => _adCountdown = null);
        widget.appState.addCoins(15);
        final lang = widget.appState.lang;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.tr(lang, '+15 Eon Coins earned', '+15 Pièces Eon gagnées'))),
        );
      } else {
        setState(() => _adCountdown = _adCountdown! - 1);
      }
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.appState.lang;
    final packs = [
      (50, S.tr(lang, 'Starter Pouch', 'Bourse Débutant'), '\$0.99'),
      (180, S.tr(lang, 'Arc Bundle', 'Pack Arc'), '\$2.99'),
      (500, S.tr(lang, 'Season Vault', 'Coffre Saison'), '\$6.99'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF14161D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.tr(lang, 'Eon Coins Balance', 'Solde Pièces Eon'), style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('${widget.appState.coins}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(S.tr(lang, 'Coins', 'Pièces'), style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<AppLang>(
                segments: const [
                  ButtonSegment(value: AppLang.en, label: Text('English')),
                  ButtonSegment(value: AppLang.fr, label: Text('Français')),
                ],
                selected: {lang},
                onSelectionChanged: (v) => widget.appState.setLang(v.first),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(S.tr(lang, 'Earn Free Coins', 'Gagner des pièces gratuites'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          tileColor: const Color(0xFF14161D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.card_giftcard, color: Color(0xFFFBBF24)),
          title: Text(S.tr(lang, 'Daily Check-In Bonus', 'Bonus quotidien')),
          subtitle: Text(S.tr(lang, '+20 Coins every day', '+20 Pièces chaque jour'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
          trailing: FilledButton(
            onPressed: widget.appState.dailyClaimed ? null : widget.appState.claimDaily,
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
            child: Text(widget.appState.dailyClaimed ? S.tr(lang, 'Claimed', 'Réclamé') : S.tr(lang, 'Claim +20', 'Réclamer +20')),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: const Color(0xFF14161D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.smart_display, color: Color(0xFFF43F5E)),
          title: Text(S.tr(lang, 'Watch Short Preview', 'Regarder un aperçu')),
          subtitle: Text(S.tr(lang, '5-second reel · +15 Coins', 'Extrait de 5 s · +15 Pièces'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
          trailing: FilledButton(
            onPressed: _adCountdown != null ? null : _startPreviewAd,
            child: Text(_adCountdown != null ? '${_adCountdown}s' : S.tr(lang, 'Watch +15', 'Voir +15')),
          ),
        ),
        const SizedBox(height: 22),
        Text(S.tr(lang, 'Coin Packs', 'Packs de pièces'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...packs.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              tileColor: const Color(0xFF14161D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.monetization_on, color: Color(0xFFF59E0B)),
              title: Text('${p.$1} ${S.tr(lang, 'Coins', 'Pièces')} · ${p.$2}'),
              trailing: Text(p.$3, style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold)),
              onTap: () {
                widget.appState.addCoins(p.$1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('+${p.$1} ${S.tr(lang, 'Coins', 'Pièces')}')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
