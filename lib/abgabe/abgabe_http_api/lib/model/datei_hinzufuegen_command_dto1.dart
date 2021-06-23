        import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datei_hinzufuegen_command_dto1.g.dart';

abstract class DateiHinzufuegenCommandDto1 implements Built<DateiHinzufuegenCommandDto1, DateiHinzufuegenCommandDto1Builder> {

    
    @BuiltValueField(wireName: r'id')
    String get id;
    
    @BuiltValueField(wireName: r'name')
    String get name;

    // Boilerplate code needed to wire-up generated code
    DateiHinzufuegenCommandDto1._();

    factory DateiHinzufuegenCommandDto1([updates(DateiHinzufuegenCommandDto1Builder b)]) = _$DateiHinzufuegenCommandDto1;
    static Serializer<DateiHinzufuegenCommandDto1> get serializer => _$dateiHinzufuegenCommandDto1Serializer;

}

