library web_file_open;

import 'src/web_file_open/web_file_open_stub.dart'
    if (dart.library.js) 'src/web_file_open/web_file_open_html.dart'
    as implementation;

void openWebFile(String url, String name) =>
    implementation.openWebFile(url, name);
