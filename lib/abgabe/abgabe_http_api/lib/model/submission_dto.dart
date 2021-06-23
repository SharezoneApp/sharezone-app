        import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'submission_dto.g.dart';

abstract class SubmissionDto implements Built<SubmissionDto, SubmissionDtoBuilder> {

    
    @BuiltValueField(wireName: r'published')
    bool get published;

    // Boilerplate code needed to wire-up generated code
    SubmissionDto._();

    factory SubmissionDto([updates(SubmissionDtoBuilder b)]) = _$SubmissionDto;
    static Serializer<SubmissionDto> get serializer => _$submissionDtoSerializer;

}

