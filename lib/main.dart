import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SagaEonApp());
}

// ============================================================================
// DATA MODELS & CATALOG
// ============================================================================

enum ParticleTheme { embers, ash, rain, runes, stars }

enum EpisodeAccess { free, unlocked, timer, locked }

class StoryBeat {
  final double startSec;
  final double endSec;
  final String speaker;
  final String subtitle;
  final Color tint;

  const StoryBeat({
    required this.startSec,
    required this.endSec,
    required this.speaker,
    required this.subtitle,
    required this.tint,
  });
}

class SagaEpisode {
  final String id;
  final int number;
  final String title;
  final int durationSec;
  final EpisodeAccess access;
  final int coinCost;
  final int initialTimerSec;
  final int likes;
  final List<StoryBeat> beats;

  const SagaEpisode({
    required this.id,
    required this.number,
    required this.title,
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
  final String timeAgo;
  final String text;

  const SagaComment({
    required this.id,
    required this.author,
    required this.episodeNumber,
    required this.timeAgo,
    required this.text,
  });
}

class SagaSeries {
  final String id;
  final int rank;
  final String title;
  final String tagline;
  final String synopsis;
  final String genre;
  final String studio;
  final String rating;
  final String viewsLabel;
  final int totalEpisodesCount;
  final String posterAsset;
  final String backdropAsset;
  final ParticleTheme particleTheme;
  final Color accentColor;
  final String releaseSchedule;
  final List<SagaEpisode> episodes;
  final List<SagaComment> initialComments;

  const SagaSeries({
    required this.id,
    required this.rank,
    required this.title,
    required this.tagline,
    required this.synopsis,
    required this.genre,
    required this.studio,
    required this.rating,
    required this.viewsLabel,
    required this.totalEpisodesCount,
    required this.posterAsset,
    required this.backdropAsset,
    required this.particleTheme,
    required this.accentColor,
    required this.releaseSchedule,
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
  required List<String> titles,
}) {
  return List.generate(titles.length, (i) {
    final num = i + 1;
    final access = num <= 3
        ? EpisodeAccess.free
        : num == 4
            ? EpisodeAccess.timer
            : EpisodeAccess.locked;
    return SagaEpisode(
      id: '$sagaId-ep-$num',
      number: num,
      title: titles[i],
      durationSec: 58,
      access: access,
      coinCost: num <= 8 ? 5 : 8,
      initialTimerSec: num == 4 ? 285 : 0,
      likes: 18400 - i * 920,
      beats: [
        StoryBeat(
          startSec: 0,
          endSec: 12,
          speaker: 'Narrator',
          subtitle: '$sagaTitle — Episode $num: ${titles[i]}. The meridian bells toll past midnight.',
          tint: tintA,
        ),
        StoryBeat(
          startSec: 12,
          endSec: 27,
          speaker: hero,
          subtitle: 'Every second borrowed from the spire leaves a fracture across the lower district.',
          tint: tintB,
        ),
        StoryBeat(
          startSec: 27,
          endSec: 43,
          speaker: rival,
          subtitle: 'You still fight for a city that forgot your oath. Draw your steel and prove time obeys you.',
          tint: tintA,
        ),
        StoryBeat(
          startSec: 43,
          endSec: 58,
          speaker: hero,
          subtitle: 'Then watch the pendulum stop. Zero Hour begins now.',
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
    tagline: 'One borrowed minute. One shattered clocktower.',
    synopsis:
        'Exiled timekeeper Ren Vane wields an ember-forged katana capable of slicing sixty seconds out of fate. To rescue his sister from the Obsidian Meridian, he must outfight the Guild of Hours.',
    genre: 'Action',
    studio: 'Studio Nocturne',
    rating: '4.9',
    viewsLabel: '2.4M Views',
    totalEpisodesCount: 142,
    posterAsset: 'assets/images/poster_chrono_blade.jpg',
    backdropAsset: 'assets/images/hero_chrono_blade.jpg',
    particleTheme: ParticleTheme.embers,
    accentColor: const Color(0xFFF43F5E),
    releaseSchedule: 'Daily 20:00',
    episodes: _buildEpisodes(
      sagaId: 'chrono-blade',
      sagaTitle: 'Chrono Blade',
      hero: 'Ren Vane',
      rival: 'Marshal Kael',
      tintA: const Color.fromRGBO(244, 63, 94, 0.22),
      tintB: const Color.fromRGBO(245, 158, 11, 0.18),
      titles: const [
        'The Broken Escapement',
        'Sixty Borrowed Seconds',
        'Embers Over Ward Seven',
        'Oath of the Brass Spire',
        'Shadow of the Second Hand',
        'Duel on Rain-Slick Slate',
        'The Clockmaker Ledger',
        'Fractured Horizon',
        'Echoes Before Dawn',
        'Crimson Pendulum',
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c1',
        author: 'Kuroda_M',
        episodeNumber: 1,
        timeAgo: '14m ago',
        text: 'That clocktower opening frame hits hard in vertical full screen.',
      ),
      SagaComment(
        id: 'c2',
        author: 'SoraLine',
        episodeNumber: 2,
        timeAgo: '1h ago',
        text: '58 seconds flew by — unlocking Episode 4 with daily coins.',
      ),
    ],
  ),
  SagaSeries(
    id: 'ashen-crown',
    rank: 2,
    title: 'Ashen Crown',
    tagline: 'Beneath the eclipse, only iron remembers.',
    synopsis:
        'Betrayed on the eve of her coronation, Empress Seraphina returns from the cinder wastes with twin obsidian blades to reclaim the shattered citadel.',
    genre: 'Fantasy',
    studio: 'Iron Spire Studio',
    rating: '4.8',
    viewsLabel: '1.9M Views',
    totalEpisodesCount: 118,
    posterAsset: 'assets/images/poster_ashen_crown.jpg',
    backdropAsset: 'assets/images/poster_ashen_crown.jpg',
    particleTheme: ParticleTheme.ash,
    accentColor: const Color(0xFFEF4444),
    releaseSchedule: 'Mon · Wed · Fri',
    episodes: _buildEpisodes(
      sagaId: 'ashen-crown',
      sagaTitle: 'Ashen Crown',
      hero: 'Seraphina',
      rival: 'Lord Vaelen',
      tintA: const Color.fromRGBO(239, 68, 68, 0.22),
      tintB: const Color.fromRGBO(251, 146, 60, 0.16),
      titles: const [
        'Cinders of the First Throne',
        'Twin Blades in Ash',
        'Gate of the Fallen Guard',
        'Blood Eclipse Rising',
        'The Regent Confession',
        'Siege of Marble Bridge',
        'Crown of Cold Iron',
        'Oathbreaker Trial',
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c4',
        author: 'Mira_K',
        episodeNumber: 1,
        timeAgo: '28m ago',
        text: 'Seraphina armor design under the eclipse is incredible.',
      ),
    ],
  ),
  SagaSeries(
    id: 'rain-shogun',
    rank: 3,
    title: 'Rain Shogun: Sector 9',
    tagline: 'Steel never rusts in neon rain.',
    synopsis:
        'In a flooded vertical metropolis ruled by algorithmic syndicates, a rogue courier guards the last unencrypted human memory.',
    genre: 'Sci-Fi',
    studio: 'Kaze Works',
    rating: '4.9',
    viewsLabel: '1.6M Views',
    totalEpisodesCount: 96,
    posterAsset: 'assets/images/poster_neon_shogun.jpg',
    backdropAsset: 'assets/images/poster_neon_shogun.jpg',
    particleTheme: ParticleTheme.rain,
    accentColor: const Color(0xFFF59E0B),
    releaseSchedule: 'Tue · Thu · Sat',
    episodes: _buildEpisodes(
      sagaId: 'rain-shogun',
      sagaTitle: 'Rain Shogun',
      hero: 'Kenji-09',
      rival: 'Director Sato',
      tintA: const Color.fromRGBO(245, 158, 11, 0.18),
      tintB: const Color.fromRGBO(56, 189, 248, 0.16),
      titles: const [
        'Lanterns in Sector Nine',
        'Static Under the Bridge',
        'The Analog Visor',
        'Midnight Monorail',
        'Ghost Frequency',
        'Steel Over Asphalt',
        'Blackout Protocol',
        'Last Train from Neo-Edo',
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c6',
        author: 'TaroDrift',
        episodeNumber: 1,
        timeAgo: '42m ago',
        text: 'The rain atmosphere in vertical mode looks awesome.',
      ),
    ],
  ),
  SagaSeries(
    id: 'eclipse-pact',
    rank: 4,
    title: 'The Eclipse Pact',
    tagline: 'Every shadow answers to the blood moon.',
    synopsis:
        'Archivist Julian Thorne unlocks a forbidden celestial astrolabe that binds twin spirit wolves to his bloodline.',
    genre: 'Supernatural',
    studio: 'Moonwell Animation',
    rating: '4.7',
    viewsLabel: '1.3M Views',
    totalEpisodesCount: 108,
    posterAsset: 'assets/images/poster_eclipse_pact.jpg',
    backdropAsset: 'assets/images/poster_eclipse_pact.jpg',
    particleTheme: ParticleTheme.runes,
    accentColor: const Color(0xFFFB7185),
    releaseSchedule: 'Daily 22:00',
    episodes: _buildEpisodes(
      sagaId: 'eclipse-pact',
      sagaTitle: 'The Eclipse Pact',
      hero: 'Julian Thorne',
      rival: 'Elder Morwen',
      tintA: const Color.fromRGBO(251, 113, 133, 0.20),
      tintB: const Color.fromRGBO(250, 204, 21, 0.15),
      titles: const [
        'The Golden Astrolabe',
        'Wolves of the Pine Mist',
        'Crimson Moon Ascending',
        'Ward of Silver Ash',
        'The Seventh Grimoire',
        'Hollow Sanctuary',
        'Pact of Two Shadows',
        'Beyond the Veil',
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c7',
        author: 'Noelle_R',
        episodeNumber: 2,
        timeAgo: '3h ago',
        text: 'Julian and the shadow wolves carry this whole arc.',
      ),
    ],
  ),
  SagaSeries(
    id: 'velvet-orbit',
    rank: 5,
    title: 'Velvet Orbit',
    tagline: 'Two rival heirs above a dying ring.',
    synopsis:
        'Assigned to co-command an orbital conservatory around Saturn fading rings, rival academy pilots uncover a conspiracy.',
    genre: 'Romance',
    studio: 'Atelier Celestia',
    rating: '4.8',
    viewsLabel: '1.1M Views',
    totalEpisodesCount: 84,
    posterAsset: 'assets/images/poster_velvet_orbit.jpg',
    backdropAsset: 'assets/images/poster_velvet_orbit.jpg',
    particleTheme: ParticleTheme.stars,
    accentColor: const Color(0xFFFBBF24),
    releaseSchedule: 'Fri · Sun',
    episodes: _buildEpisodes(
      sagaId: 'velvet-orbit',
      sagaTitle: 'Velvet Orbit',
      hero: 'Claire Vance',
      rival: 'Leo Sterling',
      tintA: const Color.fromRGBO(251, 191, 36, 0.18),
      tintB: const Color.fromRGBO(99, 102, 241, 0.20),
      titles: const [
        'Conservatory in Orbit',
        'The Ringed Horizon',
        'Lanterns Under Glass',
        'Zero-Gravity Waltz',
        'Encrypted Star Chart',
        'Solar Flare Warning',
        'Starlight Confession',
        'Promise Above Saturn',
      ],
    ),
    initialComments: const [
      SagaComment(
        id: 'c8',
        author: 'Hana_S',
        episodeNumber: 1,
        timeAgo: '55m ago',
        text: 'Loving the warm starlight conservatory vibe.',
      ),
    ],
  ),
];

// ============================================================================
// APP STATE CONTROLLER
// ============================================================================

class SagaAppState extends ChangeNotifier {
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
        author: 'You',
        episodeNumber: epNum,
        timeAgo: 'Just now',
        text: text,
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
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
              BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'Watch'),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'My List'),
              BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Coins'),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// ARTWORK RENDERER (Asset or Pure-Flutter Atmospheric Fallback)
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

    return Image.asset(
      useBackdrop ? saga.backdropAsset : saga.posterAsset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
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
        // Top App Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Saga Eon',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3),
            ),
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
                        'Featured · ${featured.genre} · ${featured.totalEpisodesCount} Episodes',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        featured.title,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        featured.tagline,
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
                            label: const Text('Watch Ep. 1'),
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
                            child: const Text('Episodes'),
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
            hintText: 'Search sagas or studios...',
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
                    g,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Continue Watching
        if (continueEntries.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('Continue Watching', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                        child: SizedBox(
                          width: 54,
                          height: 72,
                          child: SagaPosterArt(saga: saga),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(saga.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                              'Ep. ${ep.number} · ${ep.title}',
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

        // Top Ranked Sagas Carousel
        const SizedBox(height: 24),
        const Text('Top Ranked Sagas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                                child: Text(
                                  saga.rank.toString().padLeft(2, '0'),
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        saga.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Text(
                        '${saga.genre} · ${saga.totalEpisodesCount} Ep',
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Catalog Grid
        const SizedBox(height: 24),
        Text(
          _selectedGenre == 'All' ? 'All Vertical Sagas' : '$_selectedGenre Sagas',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(child: Text('No sagas matched your search.', style: TextStyle(color: Colors.white54))),
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
                            Text(
                              saga.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${saga.genre} · ${saga.totalEpisodesCount} Ep · ${saga.rating}',
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
                    child: SizedBox(
                      width: 118,
                      height: 158,
                      child: SagaPosterArt(saga: widget.saga),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.saga.genre} · ${widget.saga.totalEpisodesCount} Ep · ${widget.saga.rating}',
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.saga.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.saga.studio} · ${widget.saga.releaseSchedule}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => widget.onPlayEpisode(lastEp ?? 1),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: Text(lastEp != null ? 'Resume Ep. $lastEp' : 'Watch Ep. 1'),
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
              Text(widget.saga.synopsis, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Episodes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('All')),
                      ButtonSegment(value: true, label: Text('Unlocked')),
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
                      child: Text(
                        ep.number.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    title: Text(ep.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      playable
                          ? '0:${ep.durationSec} · ${ep.access == EpisodeAccess.free ? 'Free' : 'Unlocked'}'
                          : isTimer
                              ? '0:${ep.durationSec} · Free in ${_formatTimer(timerSec)}'
                              : '0:${ep.durationSec} · ${ep.coinCost} Coins',
                      style: TextStyle(
                        fontSize: 12,
                        color: playable
                            ? const Color(0xFF34D399)
                            : isTimer
                                ? const Color(0xFFFBBF24)
                                : Colors.white54,
                      ),
                    ),
                    trailing: playable
                        ? const Text('Watch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                        : widget.appState.coins >= ep.coinCost
                            ? TextButton(
                                onPressed: () {
                                  if (widget.appState.unlockEpisode(ep)) {
                                    widget.onPlayEpisode(ep.number);
                                  }
                                },
                                child: Text('Unlock ${ep.coinCost}c', style: const TextStyle(color: Color(0xFFF43F5E))),
                              )
                            : TextButton(
                                onPressed: widget.onGoToCoins,
                                child: const Text('Get Coins', style: TextStyle(color: Color(0xFFFBBF24))),
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
    _pageController.animateToPage(
      idx,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
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
                          Text('Comments (${comments.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                                Text('${c.author} · Ep. ${c.episodeNumber} · ${c.timeAgo}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                                const SizedBox(height: 4),
                                Text(c.text, style: const TextStyle(fontSize: 14)),
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
                                hintText: 'Add a comment...',
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
                            child: const Text('Post'),
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
                    Text('${widget.saga.title} · Episodes', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                    return ListTile(
                      onTap: () {
                        Navigator.pop(ctx);
                        widget.onSelectEpisode(ep.number);
                      },
                      title: Text(
                        '${ep.number.toString().padLeft(2, '0')} · ${ep.title}',
                        style: TextStyle(color: isCurrent ? const Color(0xFFF43F5E) : Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      trailing: Text(
                        playable ? (isCurrent ? 'Playing' : 'Play') : '${ep.coinCost} Coins',
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
        // Background Artwork with Ken Burns motion
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
        // Contrast Scrims
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

        // Tap anywhere to Play/Pause
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
                      'Ep. ${widget.episode.number} · ${widget.episode.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
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
              Text(
                '${((widget.episode.likes + (isLiked ? 1 : 0)) / 1000).toStringAsFixed(1)}K',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              IconButton(
                onPressed: _openCommentsSheet,
                icon: const Icon(Icons.comment_outlined, size: 27),
              ),
              Text('$commentsCount', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(
                onPressed: () => widget.appState.toggleBookmark(widget.saga.id),
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: isBookmarked ? const Color(0xFFFBBF24) : Colors.white, size: 28),
              ),
              Text(isBookmarked ? 'Saved' : 'Save', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(
                onPressed: _openEpisodesSheet,
                icon: const Icon(Icons.list_alt, size: 28),
              ),
              const Text('Episodes', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${widget.saga.title} - Ep ${widget.episode.number}'));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Episode link copied')));
                },
                icon: const Icon(Icons.share_outlined, size: 25),
              ),
            ],
          ),
        ),

        // Lower-Third Dialogue & Scrubber OR Locked Episode Overlay
        if (playable)
          Positioned(
            left: 16,
            right: 72,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(beat.speaker, style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(beat.subtitle, style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500)),
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
                    Text(
                      '${_clock(_currentSec)} / ${_clock(widget.episode.durationSec.toDouble())}',
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
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
                Text(
                  '${widget.saga.title} · Episode ${widget.episode.number}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.episode.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.episode.access == EpisodeAccess.timer && timerLeft > 0
                      ? 'Unlocks free in ${_clock(timerLeft.toDouble())} or unlock immediately.'
                      : 'Unlock this episode to continue watching.',
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
                          label: Text('Unlock · ${widget.episode.coinCost} Coins'),
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
                        )
                      : FilledButton.icon(
                          onPressed: widget.onGoToCoins,
                          icon: const Icon(Icons.monetization_on, size: 18),
                          label: Text('Get Free Coins (${widget.appState.coins})'),
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.black),
                        ),
                ),
                const SizedBox(height: 10),
                TextButton(onPressed: _openEpisodesSheet, child: const Text('Browse Episodes')),
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
    final saved = kSagasCatalog.where((s) => widget.appState.bookmarkedIds.contains(s.id)).toList();
    final history = widget.appState.watchProgress.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('My List', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text('Saved (${saved.length})')),
            ButtonSegment(value: true, label: Text('History (${history.length})')),
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
                    const Text('Your watchlist is empty.', style: TextStyle(color: Colors.white60)),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: widget.onBrowseDiscover, child: const Text('Browse Sagas')),
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
                          Text('${saga.genre} · ${saga.totalEpisodesCount} Ep', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FilledButton.icon(
                                onPressed: () => widget.onPlayEpisode(saga.id, resumeEp),
                                icon: const Icon(Icons.play_arrow, size: 16),
                                label: Text('Watch Ep. $resumeEp'),
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
              subtitle: Text('Ep. ${ep.number} · ${ep.title}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: const Icon(Icons.play_arrow, color: Color(0xFFF43F5E)),
            );
          }),
      ],
    );
  }
}

// ============================================================================
// SCREEN 5: EON COINS WALLET
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('+15 Eon Coins earned')));
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
    final packs = const [
      (50, 'Starter Pouch', '\$0.99'),
      (180, 'Arc Bundle', '\$2.99'),
      (500, 'Season Vault', '\$6.99'),
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
              const Text('Eon Coins Balance', style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('${widget.appState.coins}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Text('Coins', style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.appState.unlockedIds.length} premium episodes unlocked',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Earn Free Coins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          tileColor: const Color(0xFF14161D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.card_giftcard, color: Color(0xFFFBBF24)),
          title: const Text('Daily Check-In Bonus'),
          subtitle: const Text('+20 Coins every day', style: TextStyle(color: Colors.white54, fontSize: 12)),
          trailing: FilledButton(
            onPressed: widget.appState.dailyClaimed ? null : widget.appState.claimDaily,
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
            child: Text(widget.appState.dailyClaimed ? 'Claimed' : 'Claim +20'),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: const Color(0xFF14161D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.smart_display, color: Color(0xFFF43F5E)),
          title: const Text('Watch Short Preview'),
          subtitle: const Text('5-second reel · +15 Coins', style: TextStyle(color: Colors.white54, fontSize: 12)),
          trailing: FilledButton(
            onPressed: _adCountdown != null ? null : _startPreviewAd,
            child: Text(_adCountdown != null ? '${_adCountdown}s' : 'Watch +15'),
          ),
        ),
        const SizedBox(height: 22),
        const Text('Coin Packs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...packs.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              tileColor: const Color(0xFF14161D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.monetization_on, color: Color(0xFFF59E0B)),
              title: Text('${p.$1} Coins · ${p.$2}'),
              trailing: Text(p.$3, style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold)),
              onTap: () {
                widget.appState.addCoins(p.$1);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added +${p.$1} Coins')));
              },
            ),
          ),
        ),
      ],
    );
  }
}
