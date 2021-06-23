            import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto1.dart';
            import 'package:built_collection/built_collection.dart';
        import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dateien_hinzufuegen_command_dto.g.dart';

abstract class DateienHinzufuegenCommandDto implements Built<DateienHinzufuegenCommandDto, DateienHinzufuegenCommandDtoBuilder> {

    
    @BuiltValueField(wireName: r'hinzufuegenCommands')
    BuiltList<DateiHinzufuegenCommandDto1> get hinzufuegenCommands;

    // Boilerplate code needed to wire-up generated code
    DateienHinzufuegenCommandDto._();

    factory DateienHinzufuegenCommandDto([updates(DateienHinzufuegenCommandDtoBuilder b)]) = _$DateienHinzufuegenCommandDto;
    static Serializer<DateienHinzufuegenCommandDto> get serializer => _$dateienHinzufuegenCommandDtoSerializer;

}

