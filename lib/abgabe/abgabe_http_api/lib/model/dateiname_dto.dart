        import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dateiname_dto.g.dart';

abstract class DateinameDto implements Built<DateinameDto, DateinameDtoBuilder> {

    
    @BuiltValueField(wireName: r'name')
    String get name;

    // Boilerplate code needed to wire-up generated code
    DateinameDto._();

    factory DateinameDto([updates(DateinameDtoBuilder b)]) = _$DateinameDto;
    static Serializer<DateinameDto> get serializer => _$dateinameDtoSerializer;

}

