import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';

final List<Ad> mockAds = [
  ...mockImageAds,
  ...mockVideoAds,
  ...mockHtmlAds,
  ...mockYoutubeAds,
];

final List<Ad> randomAds = [
  ...List<Ad>.generate(100, (_) => _generateAd()),
];

Ad _generateAd() {
  return Ad(
    id: faker.guid.guid(),
    creative: _generateCreative(),
    timeBlocks: faker.randomGenerator.integer(5, min: 1),
    canSkipAfter: 6,
    targetingKeywords: faker.lorem
        .words(faker.randomGenerator.integer(10, min: 5))
        .map((w) => Keyword(w))
        .toList(),
    targetingAreas: [const Area('Da Nang')],
    version: 0,
    createdAt: DateTime.now(),
    lastModifiedAt: DateTime.now(),
  );
}

Creative _generateCreative() {
  // 80% image
  final shouldReturnImage = (faker.randomGenerator.integer(10) < 8);

  if (shouldReturnImage) {
    return faker.creative.image();
  } else {
    final shouldReturnVideo = faker.randomGenerator.boolean();
    // 10% that it's video
    if (shouldReturnVideo) {
      return faker.creative.video();
    } else if (faker.randomGenerator.boolean()) {
      // 5% youtube
      return faker.creative.youtube();
    } else {
      // 5% html
      return faker.creative.html();
    }
  }
}

final List<Ad> mockVideoAds = [
  Ad(
      id: 'cf135d3a-4d95-6d0e-e904-48349e9e8c67',
      creative: VideoCreative(
          id: '8d3b4e94-c27f-c4fe-9f31-75a69f45bee4',
          urlPath: '/faker/nulla_vivamus_dictum_suspendisse_aliquet.mp4',
          filePath: null,
          format: 'mp4',
          videoLength: 34,
          fileSize: 106722),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('varius'),
        Keyword('consequat'),
        Keyword('ridiculus'),
        Keyword('aliquet'),
        Keyword('montes'),
        Keyword('etiam')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.007672'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.007687')),
  Ad(
      id: 'ff94bb8e-e633-48b4-fe82-58e240bb6179',
      creative: VideoCreative(
          id: '6a98fccd-8fc9-edf1-0f76-2f4826c6b182',
          urlPath: '/faker/commodo_fermentum_cras_volutpat_facilisi.mp4',
          filePath: null,
          format: 'mp4',
          videoLength: 27,
          fileSize: 283209),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('neque'),
        Keyword('montes'),
        Keyword('dignissim'),
        Keyword('consectetur'),
        Keyword('placerat'),
        Keyword('facilisi'),
        Keyword('at'),
        Keyword('consectetur')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.009261'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.009276')),
  Ad(
      id: 'c525a683-0924-b2c6-67c5-b6c89d1376b5',
      creative: VideoCreative(
          id: '816794f1-6436-350d-e817-da6b7107ac12',
          urlPath: '/faker/nec_penatibus_semper_mus_laoreet.mp4',
          filePath: null,
          format: 'mp4',
          videoLength: 29,
          fileSize: 169981),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('lorem'),
        Keyword('placerat'),
        Keyword('neque'),
        Keyword('dolor'),
        Keyword('mattis'),
        Keyword('amet'),
        Keyword('et'),
        Keyword('libero'),
        Keyword('fames')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.016444'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.016459')),
  Ad(
      id: '541fc517-7d6f-5695-2788-cd29ed6a299f',
      creative: VideoCreative(
          id: '03ffdd4f-6e83-50da-24d5-6845a545fb72',
          urlPath: '/faker/vulputate_vestibulum_nisi_dictum_metus.mp4',
          filePath: null,
          format: 'mp4',
          videoLength: 39,
          fileSize: 347455),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('maecenas'),
        Keyword('ornare'),
        Keyword('vulputate'),
        Keyword('eros'),
        Keyword('praesent'),
        Keyword('parturient'),
        Keyword('elit')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.018243'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.018258')),
  Ad(
      id: '6c1bd2d7-87c8-eefa-0e7d-18f8f2fc162e',
      creative: VideoCreative(
          id: 'b6fa2760-ec9d-cff6-afb2-ca869fa89a0d',
          urlPath: '/faker/praesent_id_varius_suspendisse_varius.mp4',
          filePath: null,
          format: 'mp4',
          videoLength: 33,
          fileSize: 24445),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('cursus'),
        Keyword('aenean'),
        Keyword('aenean'),
        Keyword('neque'),
        Keyword('quis'),
        Keyword('morbi')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.024458'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.024473')),
  Ad(
      id: 'd209e757-83b0-3f1d-d1a0-cb3e49322326',
      creative: VideoCreative(
          id: '58282274-d32b-06fc-5e0a-e7ab4b6b9ac8',
          urlPath: '/faker/hac_donec_gravida_sapien_cursus.mp4',
          filePath: null,
          format: 'mp4',
          videoLength: 16,
          fileSize: 95033),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('pretium'),
        Keyword('nunc'),
        Keyword('euismod'),
        Keyword('massa'),
        Keyword('etiam'),
        Keyword('enim'),
        Keyword('sapien'),
        Keyword('porttitor')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.031314'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.031341')),
];

final List<Ad> mockHtmlAds = [
  Ad(
      id: 'cdaf803d-647e-7d71-10c5-0c48cc8705ff',
      creative: HtmlCreative(
          id: '6ad7e259-4c3e-db42-3523-6d7f4e19190c',
          urlPath: '/faker/praesent_rhoncus_cum_placerat_gravida.zip',
          filePath: null,
          fileSize: 26625),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('a'),
        Keyword('aliquam'),
        Keyword('imperdiet'),
        Keyword('nascetur'),
        Keyword('donec')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028069'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028088')),
  Ad(
      id: '25d0e0be-10e9-ddb4-d787-b0ff45d98bee',
      creative: HtmlCreative(
          id: '8572ed72-3fd0-3007-2cb1-fc9cc40d43f9',
          urlPath: '/faker/netus_purus_ultricies_aliquet_natoque.zip',
          filePath: null,
          fileSize: 48953),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('dolor'),
        Keyword('cum'),
        Keyword('id'),
        Keyword('quis'),
        Keyword('vivamus'),
        Keyword('morbi'),
        Keyword('sagittis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028862'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028876')),
  Ad(
      id: '8bd2578a-095b-2720-7e07-414693224368',
      creative: HtmlCreative(
          id: '5fa9af9b-9a22-768c-23d1-24fbec2262fc',
          urlPath: '/faker/faucibus_vestibulum_fermentum_mauris_vestibulum.zip',
          filePath: null,
          fileSize: 13931),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('in'),
        Keyword('arcu'),
        Keyword('quis'),
        Keyword('habitant'),
        Keyword('magnis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.030379'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.030398')),
  Ad(
      id: 'd20e84f6-0458-0c3e-e39e-3dda2c0cbc6b',
      creative: HtmlCreative(
          id: '1a6f0a76-59e9-7b58-b58f-9c9d5b55ba6e',
          urlPath: '/faker/faucibus_mattis_ultrices_nam_nulla.zip',
          filePath: null,
          fileSize: 53938),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('curabitur'),
        Keyword('integer'),
        Keyword('ultrices'),
        Keyword('metus'),
        Keyword('viverra'),
        Keyword('facilisi'),
        Keyword('venenatis'),
        Keyword('ante')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.032769'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.032784')),
];

final List<Ad> mockYoutubeAds = [
  Ad(
      id: '95661431-e4db-c41d-02f5-f0448d019913',
      creative: YoutubeCreative(
          id: 'c3e9f693-a395-53bb-c943-46a7b7d017bb',
          urlPath: 'https://youtu.be/5_8e78ce691',
          videoLength: 20),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('elit'),
        Keyword('tortor'),
        Keyword('dis'),
        Keyword('massa'),
        Keyword('montes'),
        Keyword('sed'),
        Keyword('tristique'),
        Keyword('ultricies')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.000937'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.000952')),
  Ad(
      id: '99fe1d71-4036-a606-4c49-82c8070b2394',
      creative: YoutubeCreative(
          id: '074fa263-e268-7f30-42b4-5c714d087e8d',
          urlPath: 'https://youtu.be/0_a5b302c95',
          videoLength: 35),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('congue'),
        Keyword('vestibulum'),
        Keyword('malesuada'),
        Keyword('quis'),
        Keyword('quis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.003676'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.003691')),
  Ad(
      id: '78f5671a-bdc7-dbf4-6e7d-3dd9aa4640fb',
      creative: YoutubeCreative(
          id: '1e9d9079-103d-f183-f46d-3418017a71ac',
          urlPath: 'https://youtu.be/e_81fa8affa',
          videoLength: 38),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('convallis'),
        Keyword('interdum'),
        Keyword('integer'),
        Keyword('laoreet'),
        Keyword('felis'),
        Keyword('proin'),
        Keyword('maecenas')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.013483'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.013498')),
  Ad(
      id: 'c4280f0b-cc74-26f5-3d98-f98bfe7b6022',
      creative: YoutubeCreative(
          id: 'd6fd7918-8f43-80cb-5989-6e497384230f',
          urlPath: 'https://youtu.be/a_9adae24e1',
          videoLength: 18),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('venenatis'),
        Keyword('mus'),
        Keyword('duis'),
        Keyword('netus'),
        Keyword('nam')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.014336'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.014352')),
  Ad(
      id: 'd668f549-8423-4c95-d2d0-45d5b01ce068',
      creative: YoutubeCreative(
          id: '5598d3d4-3782-5e20-6cb9-2f313e56fb24',
          urlPath: 'https://youtu.be/d_8a3deb976',
          videoLength: 33),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('congue'),
        Keyword('magna'),
        Keyword('vel'),
        Keyword('mi'),
        Keyword('aliquet'),
        Keyword('pulvinar'),
        Keyword('netus'),
        Keyword('odio')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.020281'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.020296')),
  Ad(
      id: '5172d118-0577-94c5-9f16-9cff77820be8',
      creative: YoutubeCreative(
          id: '3d5955f0-d377-4cc0-85d1-3d1f9ad6f123',
          urlPath: 'https://youtu.be/1_2594706b5',
          videoLength: 36),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('arcu'),
        Keyword('platea'),
        Keyword('mi'),
        Keyword('vulputate'),
        Keyword('dis'),
        Keyword('orci'),
        Keyword('feugiat'),
        Keyword('purus'),
        Keyword('egestas')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.021871'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.021887')),
  Ad(
      id: '40cb0642-5f14-b598-23f6-3c74da8bde09',
      creative: YoutubeCreative(
          id: '8d5c8da6-7937-537c-36dc-bdc25c57ae5b',
          urlPath: 'https://youtu.be/e_a3e0c7015',
          videoLength: 22),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('pharetra'),
        Keyword('eu'),
        Keyword('eleifend'),
        Keyword('mattis'),
        Keyword('natoque'),
        Keyword('dapibus'),
        Keyword('sociis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028755'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028769')),
  Ad(
      id: '39c7cab1-3965-0770-82a3-1aac0ea1c059',
      creative: YoutubeCreative(
          id: 'db6cbcf3-c03c-b313-62d8-b1992863e74c',
          urlPath: 'https://youtu.be/b_f79b334cc',
          videoLength: 16),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('porttitor'),
        Keyword('proin'),
        Keyword('tortor'),
        Keyword('cras'),
        Keyword('feugiat'),
        Keyword('purus'),
        Keyword('risus'),
        Keyword('nullam'),
        Keyword('tempus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.032556'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.032571')),
];

final List<Ad> mockImageAds = [
  Ad(
      id: '98691a09-1823-d3f4-3c95-ceb2e64b9264',
      creative: ImageCreative(
          id: '413aeeb3-c890-cb61-9ac9-68ae633648d7',
          urlPath: '/faker/elementum_enim_natoque_nullam_id.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('dignissim'),
        Keyword('non'),
        Keyword('cum'),
        Keyword('ac'),
        Keyword('viverra'),
        Keyword('amet'),
        Keyword('blandit')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.987733'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.987744')),
  Ad(
      id: 'f7d0016c-790f-786d-69d8-73fb7d35258e',
      creative: ImageCreative(
          id: 'f3149ca4-7095-a21f-5205-c9cf86a89dd4',
          urlPath: '/faker/auctor_non_phasellus_ultrices_habitasse.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('tempor'),
        Keyword('elit'),
        Keyword('lobortis'),
        Keyword('placerat'),
        Keyword('blandit'),
        Keyword('quam'),
        Keyword('luctus'),
        Keyword('hac'),
        Keyword('nec')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.988578'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.988593')),
  Ad(
      id: '93daf537-d7fb-4bed-4672-1e7837fd50e9',
      creative: ImageCreative(
          id: '23fb4098-47b9-dd8c-86ef-890bf7748a90',
          urlPath: '/faker/eu_aenean_porttitor_ullamcorper_platea.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('vulputate'),
        Keyword('lacinia'),
        Keyword('est'),
        Keyword('erat'),
        Keyword('lobortis'),
        Keyword('nunc'),
        Keyword('consectetur'),
        Keyword('nulla'),
        Keyword('lobortis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.988898'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.988913')),
  Ad(
      id: '3a24f127-cc45-ab92-ee28-62a629ee9ade',
      creative: ImageCreative(
          id: 'f19e8754-9747-a109-c90f-366a1fd2131b',
          urlPath: '/faker/venenatis_quam_tempus_praesent_pretium.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('elit'),
        Keyword('congue'),
        Keyword('egestas'),
        Keyword('curabitur'),
        Keyword('lorem')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.989854'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.989869')),
  Ad(
      id: 'a4684865-5ccd-f352-ffa0-ac52397696f2',
      creative: ImageCreative(
          id: '9ee97b0c-b55e-a225-aba9-2b91e9f83fe3',
          urlPath: '/faker/magna_duis_at_hac_fringilla.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('amet'),
        Keyword('convallis'),
        Keyword('potenti'),
        Keyword('luctus'),
        Keyword('morbi'),
        Keyword('bibendum'),
        Keyword('fames'),
        Keyword('pretium')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.990171'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.990185')),
  Ad(
      id: 'd147b2e6-0854-9b96-469c-5d2af5fbc022',
      creative: ImageCreative(
          id: '994c5c04-b942-2719-facb-5f0cf3ff5f4b',
          urlPath: '/faker/ultrices_ridiculus_suscipit_egestas_nascetur.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('libero'),
        Keyword('montes'),
        Keyword('cum'),
        Keyword('parturient'),
        Keyword('cursus'),
        Keyword('cum'),
        Keyword('cursus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.991188'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.991203')),
  Ad(
      id: '13e41239-557e-180e-a3ec-be682645e64d',
      creative: ImageCreative(
          id: '401e16d3-df80-8772-895f-352200d10b68',
          urlPath: '/faker/auctor_ultrices_varius_turpis_imperdiet.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('magna'),
        Keyword('quis'),
        Keyword('ligula'),
        Keyword('potenti'),
        Keyword('interdum'),
        Keyword('justo'),
        Keyword('habitasse'),
        Keyword('habitasse')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.991453'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.991468')),
  Ad(
      id: 'a4185d70-0984-c8fd-c68d-5b5b50c4148a',
      creative: ImageCreative(
          id: '3b660924-7eb7-6a22-0a13-cd1d992f2f12',
          urlPath: '/faker/suspendisse_elit_vulputate_consequat_congue.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ligula'),
        Keyword('faucibus'),
        Keyword('porttitor'),
        Keyword('cursus'),
        Keyword('parturient'),
        Keyword('euismod')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.991699'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.991714')),
  Ad(
      id: '813b42d3-94b9-a321-013e-1778f9e1462d',
      creative: ImageCreative(
          id: 'aceb4a14-18cb-95d3-427c-ece3bb2e5a04',
          urlPath: '/faker/lacinia_leo_mus_est_purus.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('etiam'),
        Keyword('facilisis'),
        Keyword('donec'),
        Keyword('pretium'),
        Keyword('ipsum'),
        Keyword('semper'),
        Keyword('curabitur'),
        Keyword('phasellus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.991946'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.991960')),
  Ad(
      id: 'fc8d1bbc-97ab-fa51-6078-39fb2d25358f',
      creative: ImageCreative(
          id: '05b71834-f7c6-69b5-8cb3-d441d98e8032',
          urlPath: '/faker/auctor_interdum_congue_nisl_porttitor.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('magnis'),
        Keyword('egestas'),
        Keyword('vulputate'),
        Keyword('potenti'),
        Keyword('facilisi'),
        Keyword('condimentum'),
        Keyword('donec'),
        Keyword('aliquet'),
        Keyword('commodo')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.992191'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.992205')),
  Ad(
      id: 'a755318f-17b3-3261-d7ed-2b5d0662c7df',
      creative: ImageCreative(
          id: 'b824179d-3606-314a-6b11-86db18dbedcd',
          urlPath: '/faker/mauris_vel_porta_morbi_elementum.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ipsum'),
        Keyword('hendrerit'),
        Keyword('lectus'),
        Keyword('semper'),
        Keyword('facilisi'),
        Keyword('metus'),
        Keyword('diam'),
        Keyword('sagittis'),
        Keyword('mus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.993023'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.993040')),
  Ad(
      id: '620a95f9-b98e-cae2-ce54-e2fde38be5c9',
      creative: ImageCreative(
          id: '07d15c3d-4d7c-07bc-c335-e359237cee50',
          urlPath: '/faker/nulla_magna_ac_dui_felis.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('luctus'),
        Keyword('risus'),
        Keyword('malesuada'),
        Keyword('viverra'),
        Keyword('fames'),
        Keyword('venenatis'),
        Keyword('lectus'),
        Keyword('donec')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.993305'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.993320')),
  Ad(
      id: '23043642-abd5-e0ea-7044-d5d876f2f216',
      creative: ImageCreative(
          id: '3c3d2367-a361-e667-2fcf-89471e14102e',
          urlPath: '/faker/pretium_felis_vel_fringilla_ridiculus.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('blandit'),
        Keyword('odio'),
        Keyword('penatibus'),
        Keyword('sem'),
        Keyword('sit'),
        Keyword('ultricies'),
        Keyword('interdum'),
        Keyword('donec')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.993971'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.994010')),
  Ad(
      id: 'c02b281b-2009-7c09-1722-59337f57a787',
      creative: ImageCreative(
          id: '3375d677-2430-3f56-56ad-0f7fdfadf197',
          urlPath: '/faker/mattis_senectus_neque_eu_non.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('senectus'),
        Keyword('nisi'),
        Keyword('lacus'),
        Keyword('nullam'),
        Keyword('dictumst'),
        Keyword('fringilla')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.994828'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.994846')),
  Ad(
      id: 'f4dff69f-4c76-3966-8509-22aa64acd5bb',
      creative: ImageCreative(
          id: '8dd45b30-9fba-8027-3779-7773f1e605e8',
          urlPath: '/faker/enim_cursus_commodo_habitasse_lacus.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('enim'),
        Keyword('ultrices'),
        Keyword('tellus'),
        Keyword('habitant'),
        Keyword('pretium'),
        Keyword('nunc')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.996029'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.996047')),
  Ad(
      id: 'e548fab1-d6c0-1c97-e5bc-944de3d9bdcf',
      creative: ImageCreative(
          id: 'eab95d53-3770-4afd-abda-00ca2b061d21',
          urlPath: '/faker/dis_platea_dictum_porta_dis.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('leo'),
        Keyword('pulvinar'),
        Keyword('nulla'),
        Keyword('sem'),
        Keyword('mollis'),
        Keyword('nullam'),
        Keyword('dapibus'),
        Keyword('ante'),
        Keyword('porttitor')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.997926'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.997959')),
  Ad(
      id: '45553142-9ad0-e542-eec1-cf48ad36703b',
      creative: ImageCreative(
          id: '4ecbb0e6-fab4-2fd3-4781-2a35ea6e8c5d',
          urlPath: '/faker/lectus_consequat_rhoncus_id_at.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('facilisis'),
        Keyword('lorem'),
        Keyword('ut'),
        Keyword('interdum'),
        Keyword('fames')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:09.998219'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:09.998259')),
  Ad(
      id: '45754f70-53b9-bcb7-9332-9d15ed2b6c91',
      creative: ImageCreative(
          id: '6a50fbbb-57df-ddfc-5957-f8aa346eec70',
          urlPath: '/faker/ornare_ornare_nec_habitasse_imperdiet.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('cursus'),
        Keyword('sed'),
        Keyword('ridiculus'),
        Keyword('donec'),
        Keyword('neque'),
        Keyword('ullamcorper'),
        Keyword('platea'),
        Keyword('accumsan'),
        Keyword('metus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.001980'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.001995')),
  Ad(
      id: 'f6dc9cee-5e22-c3e4-4682-ea5c5a01c4b6',
      creative: ImageCreative(
          id: '314a78b6-2e09-bc84-542a-d4ba5eb0c796',
          urlPath: '/faker/tempor_etiam_molestie_pulvinar_laoreet.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('eros'),
        Keyword('amet'),
        Keyword('morbi'),
        Keyword('euismod'),
        Keyword('netus'),
        Keyword('lectus'),
        Keyword('odio')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.002201'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.002215')),
  Ad(
      id: 'd4b3889b-79e5-6843-b9e5-5273cfb4201e',
      creative: ImageCreative(
          id: 'fd00e376-8492-ecfd-ff36-d9e112c7a475',
          urlPath: '/faker/blandit_sit_faucibus_bibendum_pulvinar.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('sed'),
        Keyword('penatibus'),
        Keyword('sem'),
        Keyword('curabitur'),
        Keyword('est'),
        Keyword('dictumst')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.002408'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.002423')),
  Ad(
      id: '74e26f27-9435-6ce8-0ff5-afa34fc4d5f0',
      creative: ImageCreative(
          id: '770447c3-2f19-f29a-e1e3-00a8a7f3cfa8',
          urlPath: '/faker/accumsan_porttitor_volutpat_mollis_ultricies.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('netus'),
        Keyword('tortor'),
        Keyword('id'),
        Keyword('dapibus'),
        Keyword('purus'),
        Keyword('pretium'),
        Keyword('nunc')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.002618'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.002632')),
  Ad(
      id: 'dc30e718-f3ae-a373-d8e7-c339b453c636',
      creative: ImageCreative(
          id: 'e252620d-04e1-8319-7dd1-b9a0e5f9874e',
          urlPath: '/faker/pretium_ultrices_vestibulum_montes_nisi.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('consectetur'),
        Keyword('purus'),
        Keyword('nunc'),
        Keyword('porta'),
        Keyword('facilisis'),
        Keyword('aliquam')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.003011'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.003026')),
  Ad(
      id: 'ccafc49f-deaf-1900-3ecd-90eb9322f2d0',
      creative: ImageCreative(
          id: 'bd2eb94e-58fb-c7a8-c34b-351272a8b422',
          urlPath: '/faker/vivamus_purus_mollis_ullamcorper_id.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('velit'),
        Keyword('egestas'),
        Keyword('arcu'),
        Keyword('dui'),
        Keyword('amet'),
        Keyword('vulputate'),
        Keyword('montes'),
        Keyword('ac'),
        Keyword('venenatis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.003464'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.003478')),
  Ad(
      id: '5a6aa403-058a-b32d-05dc-6e5cd9cb6016',
      creative: ImageCreative(
          id: '6f49d0b8-3b2c-ecd5-14bf-ef8975362db7',
          urlPath: '/faker/netus_sociis_aliquet_erat_neque.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('erat'),
        Keyword('accumsan'),
        Keyword('sodales'),
        Keyword('habitasse'),
        Keyword('ante'),
        Keyword('imperdiet'),
        Keyword('vestibulum'),
        Keyword('maecenas'),
        Keyword('amet')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.003896'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.003911')),
  Ad(
      id: 'd8c681d5-7f75-a847-e495-fd0f073fbf9e',
      creative: ImageCreative(
          id: '73aeb348-b1ea-077a-59eb-8283abf388f8',
          urlPath: '/faker/ac_mattis_tempor_mus_euismod.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ante'),
        Keyword('bibendum'),
        Keyword('placerat'),
        Keyword('convallis'),
        Keyword('condimentum'),
        Keyword('gravida'),
        Keyword('quam'),
        Keyword('vulputate')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.004101'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.004115')),
  Ad(
      id: 'b96a9015-8ca4-2a93-ef90-459581c1ab9b',
      creative: ImageCreative(
          id: '6ba24079-9106-68b6-3e39-026e9ad3b18d',
          urlPath: '/faker/libero_ut_metus_urna_vestibulum.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('tellus'),
        Keyword('in'),
        Keyword('tempor'),
        Keyword('molestie'),
        Keyword('nibh'),
        Keyword('urna')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.004863'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.004878')),
  Ad(
      id: '3193bd8c-9e7c-7f31-2fc9-f3c0d6a16a0b',
      creative: ImageCreative(
          id: 'af48b6b1-4546-ec51-b229-6c09af42168e',
          urlPath: '/faker/platea_convallis_accumsan_facilisi_magnis.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ligula'),
        Keyword('sit'),
        Keyword('amet'),
        Keyword('interdum'),
        Keyword('bibendum'),
        Keyword('adipiscing'),
        Keyword('lacinia'),
        Keyword('nulla'),
        Keyword('dui')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.005385'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.005400')),
  Ad(
      id: '1950adae-6cec-31ce-27f3-bdcbe6f49498',
      creative: ImageCreative(
          id: '11956f81-62a3-3f4a-b641-531768ac0ad1',
          urlPath: '/faker/congue_porta_massa_leo_semper.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nibh'),
        Keyword('lacus'),
        Keyword('in'),
        Keyword('suscipit'),
        Keyword('eget'),
        Keyword('lacinia'),
        Keyword('magnis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.007862'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.007877')),
  Ad(
      id: 'c8157e9c-1f52-0da4-3ce7-8bebf29b4ee8',
      creative: ImageCreative(
          id: '9a231a7c-1d42-ebe4-078b-782547a1efcb',
          urlPath: '/faker/laoreet_natoque_cras_cursus_cum.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('mus'),
        Keyword('sollicitudin'),
        Keyword('nulla'),
        Keyword('accumsan'),
        Keyword('et'),
        Keyword('interdum')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.008875'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.008890')),
  Ad(
      id: 'e173aadb-9c1e-bc1b-de8a-e49845e68f5c',
      creative: ImageCreative(
          id: 'f17d1152-fead-c245-2f4d-00d243e95622',
          urlPath: '/faker/maecenas_natoque_mattis_fringilla_dolor.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ridiculus'),
        Keyword('ipsum'),
        Keyword('habitasse'),
        Keyword('eu'),
        Keyword('eleifend'),
        Keyword('semper'),
        Keyword('neque')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.009063'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.009077')),
  Ad(
      id: '8ed35700-6153-df6b-ad06-852709f1e493',
      creative: ImageCreative(
          id: 'bd65a048-1f4c-2b4a-44ce-02ddf6972ec0',
          urlPath: '/faker/quisque_ultrices_volutpat_nascetur_suscipit.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ornare'),
        Keyword('ante'),
        Keyword('cum'),
        Keyword('mattis'),
        Keyword('penatibus'),
        Keyword('purus'),
        Keyword('adipiscing'),
        Keyword('amet')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.009446'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.009461')),
  Ad(
      id: '8e2573a8-c493-4566-9277-67acd9765a87',
      creative: ImageCreative(
          id: 'bba9a2da-4e98-fc8f-180b-db98f6d73545',
          urlPath: '/faker/orci_habitasse_morbi_at_molestie.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('volutpat'),
        Keyword('ullamcorper'),
        Keyword('scelerisque'),
        Keyword('pretium'),
        Keyword('gravida'),
        Keyword('orci'),
        Keyword('congue')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.009644'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.009662')),
  Ad(
      id: '4479f226-e290-15b3-6ca3-5608a96bb67c',
      creative: ImageCreative(
          id: '18e8ac00-c533-185b-4c55-e90e51384fb1',
          urlPath: '/faker/vestibulum_leo_quam_mi_pellentesque.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('placerat'),
        Keyword('ipsum'),
        Keyword('diam'),
        Keyword('fames'),
        Keyword('sapien'),
        Keyword('curabitur'),
        Keyword('facilisis'),
        Keyword('egestas')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.010174'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.010187')),
  Ad(
      id: '1ab33a02-6374-8861-5344-9c74223003f3',
      creative: ImageCreative(
          id: 'f9f3ce57-5c72-36d0-2960-e218eeee1e89',
          urlPath: '/faker/dictum_nascetur_dictum_amet_iaculis.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nisi'),
        Keyword('imperdiet'),
        Keyword('cras'),
        Keyword('eleifend'),
        Keyword('urna'),
        Keyword('semper'),
        Keyword('mi'),
        Keyword('ipsum')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.010354'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.010369')),
  Ad(
      id: '13ef5178-d0d2-637b-6b3c-c4956f800b07',
      creative: ImageCreative(
          id: '6dec2c5e-b7df-b3f6-d33f-e03a91ca4b79',
          urlPath: '/faker/porttitor_vestibulum_eget_sociis_ultrices.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('sit'),
        Keyword('massa'),
        Keyword('feugiat'),
        Keyword('cum'),
        Keyword('lorem'),
        Keyword('nisi')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.010525'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.010539')),
  Ad(
      id: '6ba4ba64-432d-33bc-f746-56e7c9a48cb2',
      creative: ImageCreative(
          id: 'fd5a387d-8552-4598-ea11-e727a196549d',
          urlPath: '/faker/scelerisque_vivamus_fermentum_netus_porttitor.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('rhoncus'),
        Keyword('phasellus'),
        Keyword('placerat'),
        Keyword('bibendum'),
        Keyword('neque'),
        Keyword('mattis'),
        Keyword('ornare'),
        Keyword('ridiculus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.010766'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.010783')),
  Ad(
      id: '32c099c6-37db-b50f-8cf0-6c81b0a121eb',
      creative: ImageCreative(
          id: '25148834-cb68-482f-e430-f2aef057dcc4',
          urlPath: '/faker/donec_convallis_nisi_vitae_risus.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('a'),
        Keyword('non'),
        Keyword('lobortis'),
        Keyword('imperdiet'),
        Keyword('parturient'),
        Keyword('erat'),
        Keyword('vitae'),
        Keyword('euismod'),
        Keyword('nulla')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.011144'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.011184')),
  Ad(
      id: '18b27b1d-c4f3-60ce-6e49-8f6c1256a30f',
      creative: ImageCreative(
          id: '13182788-56c7-df42-21c2-0e1ecceee69c',
          urlPath: '/faker/est_magnis_magna_nec_auctor.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('lacus'),
        Keyword('orci'),
        Keyword('nec'),
        Keyword('ac'),
        Keyword('mauris'),
        Keyword('magna'),
        Keyword('praesent')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.011452'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.011470')),
  Ad(
      id: 'fef9d58e-a875-584d-6318-9723bc558e99',
      creative: ImageCreative(
          id: '2aa37232-c641-d432-85a9-55f0db041681',
          urlPath: '/faker/fusce_et_et_potenti_nam.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('vel'),
        Keyword('urna'),
        Keyword('orci'),
        Keyword('libero'),
        Keyword('sagittis'),
        Keyword('turpis'),
        Keyword('vivamus'),
        Keyword('turpis'),
        Keyword('sem')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.011702'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.011721')),
  Ad(
      id: '85964f52-3aa9-4d05-2a95-ccdb5e0c24ae',
      creative: ImageCreative(
          id: 'e7f72b12-3612-c636-b9cf-f22c86cbcd85',
          urlPath: '/faker/consequat_vestibulum_diam_mi_bibendum.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('dolor'),
        Keyword('vitae'),
        Keyword('pellentesque'),
        Keyword('dolor'),
        Keyword('tortor'),
        Keyword('fames'),
        Keyword('bibendum'),
        Keyword('aenean')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.011990'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.012010')),
  Ad(
      id: '3318a827-e211-15ab-4b1a-1fe4889acc56',
      creative: ImageCreative(
          id: 'fe26817a-47ba-c3e4-c1d9-f1ee2348069a',
          urlPath: '/faker/quam_non_euismod_platea_convallis.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('senectus'),
        Keyword('pulvinar'),
        Keyword('mauris'),
        Keyword('elementum'),
        Keyword('amet'),
        Keyword('ridiculus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.012453'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.012477')),
  Ad(
      id: '822dbf36-e4f2-698c-3b54-5c283fc7de00',
      creative: ImageCreative(
          id: '913c4f39-a890-dbf5-9835-a0dc64b3770d',
          urlPath: '/faker/ornare_sociis_praesent_dignissim_lorem.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('suscipit'),
        Keyword('accumsan'),
        Keyword('phasellus'),
        Keyword('pharetra'),
        Keyword('pharetra'),
        Keyword('massa'),
        Keyword('aliquam')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.012938'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.012987')),
  Ad(
      id: 'f2bab61d-02b0-2257-b6ac-5b5fce50a20f',
      creative: ImageCreative(
          id: '31f4c9a6-3310-7533-8d0f-727a75fbe65c',
          urlPath: '/faker/mollis_ac_dignissim_maecenas_mattis.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('suscipit'),
        Keyword('blandit'),
        Keyword('eu'),
        Keyword('sapien'),
        Keyword('a')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.013286'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.013303')),
  Ad(
      id: '8f542b06-d648-935d-cea6-290fdccea6ff',
      creative: ImageCreative(
          id: '24ce2e89-6a06-c781-a91a-ba7d3c185300',
          urlPath: '/faker/nec_fermentum_tempus_dictum_pharetra.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('massa'),
        Keyword('et'),
        Keyword('amet'),
        Keyword('facilisi'),
        Keyword('ultrices'),
        Keyword('cras'),
        Keyword('fermentum'),
        Keyword('ac')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.014556'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.014579')),
  Ad(
      id: '61cea8c2-74ab-81f9-994a-b8692fd48a03',
      creative: ImageCreative(
          id: '195b0298-79ca-72b6-95d7-20b0fe82c108',
          urlPath: '/faker/faucibus_posuere_habitasse_magnis_risus.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('aenean'),
        Keyword('quisque'),
        Keyword('scelerisque'),
        Keyword('massa'),
        Keyword('rhoncus'),
        Keyword('facilisi'),
        Keyword('sollicitudin'),
        Keyword('habitant')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.014895'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.014924')),
  Ad(
      id: 'f67cc84d-4838-0b28-a187-af7325d12feb',
      creative: ImageCreative(
          id: 'd6535540-a178-1053-c39d-17f7b054c28e',
          urlPath: '/faker/congue_maecenas_eros_purus_hac.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nunc'),
        Keyword('urna'),
        Keyword('sem'),
        Keyword('netus'),
        Keyword('nisi'),
        Keyword('nulla'),
        Keyword('velit'),
        Keyword('nascetur'),
        Keyword('metus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.015291'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.016013')),
  Ad(
      id: '3516df8b-e81b-ad90-a0c5-705117ce9e97',
      creative: ImageCreative(
          id: '91ac1645-9d2c-81ca-4cb2-1d5ab7379272',
          urlPath: '/faker/vel_neque_tellus_fusce_ullamcorper.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('cursus'),
        Keyword('facilisis'),
        Keyword('bibendum'),
        Keyword('sit'),
        Keyword('cum'),
        Keyword('dui'),
        Keyword('viverra'),
        Keyword('semper'),
        Keyword('rhoncus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.016213'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.016228')),
  Ad(
      id: '90e79658-f08b-e693-f024-1cf8d61067ea',
      creative: ImageCreative(
          id: 'c6e116a4-06e8-d97b-3c84-f41c34aa4055',
          urlPath: '/faker/habitasse_dapibus_aliquam_dis_volutpat.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('eros'),
        Keyword('condimentum'),
        Keyword('sollicitudin'),
        Keyword('viverra'),
        Keyword('habitant'),
        Keyword('luctus'),
        Keyword('auctor'),
        Keyword('sit')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.016618'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.016632')),
  Ad(
      id: '15864dd4-310e-b9ae-6a3e-b825f5c018a5',
      creative: ImageCreative(
          id: '9a80c37f-cec2-442b-8d47-a63411386f6e',
          urlPath: '/faker/suscipit_libero_mauris_dictumst_dictum.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nascetur'),
        Keyword('tincidunt'),
        Keyword('libero'),
        Keyword('tristique'),
        Keyword('platea')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.017891'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.017905')),
  Ad(
      id: 'f20d4364-3332-169a-db17-4c4afcf7969e',
      creative: ImageCreative(
          id: '3a2f55fe-1480-476d-ab0d-d37363568147',
          urlPath: '/faker/semper_potenti_pulvinar_tincidunt_parturient.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ipsum'),
        Keyword('eget'),
        Keyword('scelerisque'),
        Keyword('habitasse'),
        Keyword('adipiscing'),
        Keyword('elementum'),
        Keyword('phasellus'),
        Keyword('tellus'),
        Keyword('dui')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.018068'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.018082')),
  Ad(
      id: '8dae9b38-4eea-fab8-7a25-f20bcc8e39c9',
      creative: ImageCreative(
          id: '5bd0ad93-be5e-71b0-1302-b0184dc1bcb4',
          urlPath: '/faker/aliquet_pellentesque_elit_cum_fringilla.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('dignissim'),
        Keyword('mi'),
        Keyword('fermentum'),
        Keyword('consequat'),
        Keyword('vivamus'),
        Keyword('mus'),
        Keyword('aliquet')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.018660'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.018674')),
  Ad(
      id: '8149bd32-c7a5-d7e9-683e-cd3a0aa4eebe',
      creative: ImageCreative(
          id: 'd040277e-9726-0514-df79-4556efee6b3a',
          urlPath: '/faker/dictumst_eros_placerat_orci_ultricies.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('auctor'),
        Keyword('lobortis'),
        Keyword('morbi'),
        Keyword('aliquam'),
        Keyword('interdum'),
        Keyword('orci'),
        Keyword('est'),
        Keyword('elit'),
        Keyword('dolor')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.018825'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.018839')),
  Ad(
      id: 'a3077156-0de3-fb80-253e-64e2a3ffb27a',
      creative: ImageCreative(
          id: 'c9db66c7-ca92-51f0-7ae2-18cd1987356b',
          urlPath: '/faker/sodales_dui_ac_dolor_non.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('dapibus'),
        Keyword('gravida'),
        Keyword('non'),
        Keyword('habitant'),
        Keyword('sagittis'),
        Keyword('sapien')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.019471'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.019486')),
  Ad(
      id: 'c7d276d9-dd8c-dddc-3f01-3404b9bd4919',
      creative: ImageCreative(
          id: '625daca7-28c9-582f-4f28-6363027941a4',
          urlPath: '/faker/eros_ultricies_aliquet_non_congue.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('adipiscing'),
        Keyword('consequat'),
        Keyword('condimentum'),
        Keyword('in'),
        Keyword('potenti'),
        Keyword('condimentum'),
        Keyword('iaculis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.020105'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.020120')),
  Ad(
      id: '7cc43733-cf9d-5778-2c78-e3054c0273e2',
      creative: ImageCreative(
          id: 'e176a9e2-d2ec-a893-ab4b-d1e64c8650e9',
          urlPath: '/faker/vestibulum_faucibus_aliquet_amet_nec.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('erat'),
        Keyword('id'),
        Keyword('fusce'),
        Keyword('dolor'),
        Keyword('eu'),
        Keyword('posuere')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.020435'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.020450')),
  Ad(
      id: '9b137f80-ba20-1fc6-0d4a-9bc5fd2a520f',
      creative: ImageCreative(
          id: '424490dd-6eec-52e8-ec82-38d5956b5bce',
          urlPath: '/faker/proin_dignissim_dignissim_nisl_eleifend.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('feugiat'),
        Keyword('nunc'),
        Keyword('orci'),
        Keyword('convallis'),
        Keyword('sodales')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.020597'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.020612')),
  Ad(
      id: 'f2217ef3-ddcc-c8ed-a037-db1dbde8bd10',
      creative: ImageCreative(
          id: 'bb130071-ec66-40ae-5be2-4427eddf0e12',
          urlPath: '/faker/elit_bibendum_facilisis_suscipit_imperdiet.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('tempor'),
        Keyword('id'),
        Keyword('odio'),
        Keyword('habitant'),
        Keyword('elementum'),
        Keyword('arcu'),
        Keyword('sollicitudin'),
        Keyword('sed'),
        Keyword('suspendisse')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.020775'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.020790')),
  Ad(
      id: 'ae7f4e16-90dc-c7c0-10b4-254c662b0e08',
      creative: ImageCreative(
          id: '2323ca31-a812-af6f-ac4f-36794c1904d1',
          urlPath: '/faker/fringilla_commodo_diam_commodo_vulputate.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('in'),
        Keyword('consectetur'),
        Keyword('rhoncus'),
        Keyword('hac'),
        Keyword('faucibus'),
        Keyword('pharetra'),
        Keyword('vel'),
        Keyword('magnis'),
        Keyword('quisque')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.021318'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.021333')),
  Ad(
      id: '101417db-98d4-1e90-4e81-9338add98c05',
      creative: ImageCreative(
          id: '6422422c-b076-39e3-c927-2ea700957a84',
          urlPath: '/faker/ac_tellus_fermentum_tortor_vitae.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nam'),
        Keyword('bibendum'),
        Keyword('et'),
        Keyword('ultricies'),
        Keyword('vel')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.021714'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.021728')),
  Ad(
      id: 'd49edfa7-7db3-12f7-e42a-cf9c79dc9641',
      creative: ImageCreative(
          id: '56f38837-0794-4e4a-679f-459ca394aa53',
          urlPath: '/faker/blandit_luctus_rhoncus_praesent_purus.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('habitant'),
        Keyword('tincidunt'),
        Keyword('convallis'),
        Keyword('mollis'),
        Keyword('platea'),
        Keyword('semper')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.022032'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.022046')),
  Ad(
      id: '9b122b17-65a0-ed8e-a0a7-3b64cd99e599',
      creative: ImageCreative(
          id: '91e09ca9-52df-0f0b-1d94-a5bfa6e748d7',
          urlPath: '/faker/auctor_nulla_pulvinar_justo_ultricies.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ligula'),
        Keyword('tristique'),
        Keyword('semper'),
        Keyword('accumsan'),
        Keyword('porta'),
        Keyword('egestas'),
        Keyword('netus'),
        Keyword('lobortis'),
        Keyword('habitant')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.022192'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.022263')),
  Ad(
      id: '1ac39ecf-6dca-c108-e0f4-506d3794b607',
      creative: ImageCreative(
          id: 'facd191d-79d1-a1e7-881d-dc9b818c1fb8',
          urlPath: '/faker/sollicitudin_volutpat_etiam_netus_pretium.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('libero'),
        Keyword('velit'),
        Keyword('neque'),
        Keyword('aliquam'),
        Keyword('dis'),
        Keyword('viverra'),
        Keyword('rhoncus')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.023420'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.024216')),
  Ad(
      id: 'cae34954-8f7d-7a8f-3ffa-410fa1b51d3e',
      creative: ImageCreative(
          id: 'd49577f6-ec48-2985-8672-b51b4346ff1e',
          urlPath: '/faker/scelerisque_pulvinar_feugiat_imperdiet_ipsum.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('ridiculus'),
        Keyword('sodales'),
        Keyword('tempor'),
        Keyword('mauris'),
        Keyword('neque'),
        Keyword('mauris'),
        Keyword('orci'),
        Keyword('ut')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.024339'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.024354')),
  Ad(
      id: '7c7cb9de-f734-0e76-c61a-ecc5610cff09',
      creative: ImageCreative(
          id: '34a9cb79-7bde-4072-172e-984fc970ef57',
          urlPath: '/faker/gravida_ligula_pharetra_dictumst_morbi.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('phasellus'),
        Keyword('integer'),
        Keyword('bibendum'),
        Keyword('nam'),
        Keyword('cursus'),
        Keyword('habitasse'),
        Keyword('vel')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.024641'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.024660')),
  Ad(
      id: '23486caf-2a88-37a4-b192-1dbaa64ef96b',
      creative: ImageCreative(
          id: '990da4ea-79ac-455c-f671-23d48887aa86',
          urlPath: '/faker/sapien_penatibus_viverra_lobortis_dictum.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('interdum'),
        Keyword('curabitur'),
        Keyword('etiam'),
        Keyword('non'),
        Keyword('leo')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.024853'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.024871')),
  Ad(
      id: '936d3dff-4b6b-9e69-d467-3ab7e3ea9f63',
      creative: ImageCreative(
          id: 'd1589ceb-3e6e-6baa-6573-884ebe75a9a9',
          urlPath: '/faker/aliquet_dis_eleifend_praesent_pharetra.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('dapibus'),
        Keyword('id'),
        Keyword('massa'),
        Keyword('accumsan'),
        Keyword('turpis'),
        Keyword('euismod')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.025013'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.025031')),
  Ad(
      id: '7d420316-893a-ab21-71b6-54fd39fec605',
      creative: ImageCreative(
          id: 'fe977e18-dfdf-9017-0c9d-531a224df944',
          urlPath: '/faker/viverra_lacinia_auctor_venenatis_nulla.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('venenatis'),
        Keyword('velit'),
        Keyword('libero'),
        Keyword('habitant'),
        Keyword('non'),
        Keyword('senectus'),
        Keyword('purus'),
        Keyword('rhoncus'),
        Keyword('molestie')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028270'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028299')),
  Ad(
      id: '1e68de6b-46e3-22a5-bec4-4f4e59756ba3',
      creative: ImageCreative(
          id: '4627e642-06b6-82df-d1cf-884aa6a51da9',
          urlPath: '/faker/aliquet_euismod_porta_facilisis_ante.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('facilisis'),
        Keyword('tristique'),
        Keyword('vulputate'),
        Keyword('erat'),
        Keyword('libero'),
        Keyword('vel'),
        Keyword('aliquam')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028428'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028443')),
  Ad(
      id: '32293f99-b8ad-0ef6-7a16-372ee0713726',
      creative: ImageCreative(
          id: 'f426727f-02a4-e059-68de-7ede43cbb53d',
          urlPath: '/faker/cursus_diam_nullam_vulputate_curabitur.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nulla'),
        Keyword('egestas'),
        Keyword('posuere'),
        Keyword('ridiculus'),
        Keyword('mollis'),
        Keyword('nunc'),
        Keyword('feugiat'),
        Keyword('consequat'),
        Keyword('nam')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028536'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028551')),
  Ad(
      id: 'fe0d58e1-f0ca-9e0b-33a3-1a071641b511',
      creative: ImageCreative(
          id: '22d5545d-8aab-6577-28c8-1895bdf24cc4',
          urlPath: '/faker/porta_at_dis_at_leo.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('magna'),
        Keyword('pellentesque'),
        Keyword('magna'),
        Keyword('auctor'),
        Keyword('fames'),
        Keyword('arcu')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028643'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.028659')),
  Ad(
      id: '01135c3e-e45f-1d02-d840-84f507a03689',
      creative: ImageCreative(
          id: '9c459501-dcf6-a5ca-8b9a-07ce750c4b13',
          urlPath: '/faker/cum_tempus_gravida_leo_amet.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('cursus'),
        Keyword('fermentum'),
        Keyword('ultrices'),
        Keyword('quis'),
        Keyword('cras'),
        Keyword('fusce'),
        Keyword('magnis'),
        Keyword('posuere')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.028969'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.029050')),
  Ad(
      id: '8e711198-9d4e-b6c8-f75a-fe4b4cf2d51d',
      creative: ImageCreative(
          id: '20fd7cbe-dcc0-a223-9bd6-588d59b67eb4',
          urlPath: '/faker/vestibulum_semper_cras_netus_felis.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('potenti'),
        Keyword('phasellus'),
        Keyword('nec'),
        Keyword('integer'),
        Keyword('elit'),
        Keyword('nisi'),
        Keyword('vel')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.029145'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.029159')),
  Ad(
      id: 'cf003ad5-cbb1-25ff-1f06-11ac79d974f3',
      creative: ImageCreative(
          id: 'a3c93f61-d553-8e2b-131f-6a0f44904095',
          urlPath: '/faker/feugiat_lacinia_eros_ultricies_convallis.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('consequat'),
        Keyword('vel'),
        Keyword('aenean'),
        Keyword('mattis'),
        Keyword('nisl'),
        Keyword('ipsum'),
        Keyword('aenean'),
        Keyword('velit')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.031170'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.031187')),
  Ad(
      id: '117f988c-c093-974c-9bfd-62fb8b6e9e49',
      creative: ImageCreative(
          id: '05dc7ede-ae16-2278-cd52-1e67c46b81e2',
          urlPath: '/faker/sit_ullamcorper_non_commodo_faucibus.jpg',
          filePath: null),
      timeBlocks: 3,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('magna'),
        Keyword('lacinia'),
        Keyword('donec'),
        Keyword('metus'),
        Keyword('viverra'),
        Keyword('tortor'),
        Keyword('eleifend'),
        Keyword('suspendisse'),
        Keyword('praesent')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.031486'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.031518')),
  Ad(
      id: '13d48d48-6870-25e9-aa06-754bcb8346dc',
      creative: ImageCreative(
          id: 'ae2b739b-e896-0a34-0322-4671d5898c93',
          urlPath: '/faker/semper_semper_felis_senectus_aliquam.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('libero'),
        Keyword('ridiculus'),
        Keyword('tortor'),
        Keyword('ante'),
        Keyword('porttitor'),
        Keyword('sociis'),
        Keyword('viverra')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.032667'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.032681')),
  Ad(
      id: 'bfaf5c17-f794-58f9-d43a-538cae88151b',
      creative: ImageCreative(
          id: '5006bb7a-7f48-4352-d6fe-c6b7e9acb4d2',
          urlPath: '/faker/diam_sapien_dictumst_tincidunt_nullam.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('mi'),
        Keyword('augue'),
        Keyword('vestibulum'),
        Keyword('netus'),
        Keyword('facilisis'),
        Keyword('fermentum'),
        Keyword('ac'),
        Keyword('hendrerit')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.032870'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.032885')),
  Ad(
      id: '630428d4-c527-771e-320e-0037c3db4e3d',
      creative: ImageCreative(
          id: '42182a2f-3ac7-a109-b42a-a366f30dbf5a',
          urlPath: '/faker/duis_ut_porttitor_praesent_hac.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('tempor'),
        Keyword('justo'),
        Keyword('natoque'),
        Keyword('dictum'),
        Keyword('semper'),
        Keyword('risus'),
        Keyword('eros')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.032971'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.032986')),
  Ad(
      id: 'dd20b87e-6f97-61fb-f3ee-12aea5c64866',
      creative: ImageCreative(
          id: 'de66e72a-fa55-eca0-b8b4-43183c1275c2',
          urlPath: '/faker/fusce_neque_semper_turpis_felis.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('praesent'),
        Keyword('phasellus'),
        Keyword('ligula'),
        Keyword('ultrices'),
        Keyword('senectus'),
        Keyword('lobortis')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.033072'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.033086')),
  Ad(
      id: '337933f7-8fd9-83e7-bff6-007f2a3e8b8b',
      creative: ImageCreative(
          id: '2951a60f-b10f-e518-0e6f-982320ab48ef',
          urlPath: '/faker/turpis_donec_ornare_nibh_ullamcorper.jpg',
          filePath: null),
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('pulvinar'),
        Keyword('nisl'),
        Keyword('curabitur'),
        Keyword('est'),
        Keyword('nec'),
        Keyword('ante'),
        Keyword('erat'),
        Keyword('tempus'),
        Keyword('potenti')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.033202'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.033237')),
  Ad(
      id: '338f5a31-56d2-a531-7de1-0f3c41c9b09a',
      creative: ImageCreative(
          id: '521291f7-2976-e233-424b-5728321be3a4',
          urlPath: '/faker/natoque_felis_tempor_tristique_sem.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('cras'),
        Keyword('neque'),
        Keyword('nascetur'),
        Keyword('nec'),
        Keyword('eget'),
        Keyword('semper'),
        Keyword('lacinia'),
        Keyword('sapien')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.033319'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.033341')),
  Ad(
      id: '5aa255af-127d-5e13-597a-891f52ac2470',
      creative: ImageCreative(
          id: '3325148e-83bc-fb69-fd4d-e9734342128c',
          urlPath: '/faker/pretium_est_feugiat_quam_nascetur.jpg',
          filePath: null),
      timeBlocks: 2,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('aliquet'),
        Keyword('ligula'),
        Keyword('nascetur'),
        Keyword('ipsum'),
        Keyword('erat'),
        Keyword('orci'),
        Keyword('venenatis'),
        Keyword('gravida'),
        Keyword('justo')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.033428'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.033443')),
  Ad(
      id: '7315466c-bf28-5ac2-bbee-8814b333c44b',
      creative: ImageCreative(
          id: '245e32ea-bbd6-0d2e-6be1-2bde0ac7367d',
          urlPath: '/faker/eros_facilisi_enim_maecenas_integer.jpg',
          filePath: null),
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('pretium'),
        Keyword('congue'),
        Keyword('velit'),
        Keyword('consequat'),
        Keyword('ante'),
        Keyword('venenatis'),
        Keyword('rhoncus'),
        Keyword('nibh')
      ],
      targetingAreas: [Area('Da Nang')],
      version: 0,
      createdAt: DateTime.parse('2020-08-13 09:34:10.033530'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.033544'))
];
