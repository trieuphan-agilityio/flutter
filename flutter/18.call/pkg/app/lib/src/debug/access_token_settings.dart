import 'package:app/app_services.dart';
import 'package:app/core.dart';
import 'package:app/src/stores/app_settings/app_settings_store.dart';
import 'package:app/src/stores/twilio_access_token/debug_twilio_access_token_store.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_factory.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

class AccessTokenSettings extends StatefulWidget {
  @override
  _AccessTokenSettingsState createState() => _AccessTokenSettingsState();
}

class _AccessTokenSettingsState extends State<AccessTokenSettings> {
  GlobalKey _formKey = GlobalKey<FormState>();

  String _accessToken;
  TextEditingController _textController;

  @override
  void initState() {
    _accessToken = '';
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SharedPreferences prefs = AppServices.of(context).prefs;
    final debugStore = DebugTwilioAccessTokenStore(prefs: prefs);

    return Scaffold(
      appBar: AppBar(title: Text('Access Token Settings')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: debugStore.fetchTwilioAccessToken(),
          builder: (_, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Container();
              default:
                return buildMainContent(snapshot.data);
            }
          },
        ),
      ),
    );
  }

  Widget buildMainContent(String initialAccessToken) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: initialAccessToken,
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
                helperText: 'Set an Access Token from Twilio Console',
              ),
              maxLines: 6,
              onSaved: (newValue) {
                setState(() => _accessToken = newValue);
              },
            ),
            const SizedBox(height: 32),
            RaisedButton(
              onPressed: () {
                FormState form = _formKey.currentState;
                form.save();
                setAccessTokenAndRefreshApp();
              },
              child: Text('Save'),
            ),
            FlatButton(
              onPressed: () => cleanAccessTokenAndRefreshApp(),
              child: Text('Clean Token'),
            ),
          ],
        ),
      ),
    );
  }

  cleanAccessTokenAndRefreshApp() {
    final AppServices appServices = AppServices.of(context);
    final AppSettingsStoreWriting appSettingsStore =
        appServices.appSettingsStore;

    appSettingsStore.twilioAccessTokenMode = TwilioAccessTokenMode.fixed;

    DebugTwilioAccessTokenStore(
      prefs: appServices.prefs,
    ).twilioAccessToken = '';

    _refreshApp();
  }

  setAccessTokenAndRefreshApp() {
    if (_accessToken != null && _accessToken != '') {
      final AppServices appServices = AppServices.of(context);
      final AppSettingsStoreWriting appSettingsStore =
          appServices.appSettingsStore;

      appSettingsStore.twilioAccessTokenMode = TwilioAccessTokenMode.debug;

      DebugTwilioAccessTokenStore(
        prefs: appServices.prefs,
      ).twilioAccessToken = _accessToken;
    }

    _refreshApp();
  }

  _refreshApp() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/');
  }
}
