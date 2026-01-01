import 'package:flutter_guid/flutter_guid_error.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Equality Tests:", () {
    test("Case insensitive equality works", () {
      final guidAlpha = new Guid("ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");
      final guidBeta = new Guid("AC3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");

      final areEqual = guidAlpha == guidBeta;

      expect(true, areEqual);
    });

    test("Null values in testing don't throw exception", () {
      final guidAlpha = new Guid("");
      Guid? guidBeta;

      final areEqual = guidAlpha == guidBeta;

      expect(areEqual, false);
    });
  });

  group("Validity Tests", () {
    _initializer(String? value, bool expectException) {
      if (expectException) {
        expect(() => new Guid(value), throwsA((e) {
          return e != null && e is FlutterGuidError;
        }));
      } else {
        final guid = new Guid(value);
        final expectedValue =
            (value == null || value.isEmpty) ? Guid.defaultValue.value : value;
        expect(guid.value, expectedValue);
        expect(guid.toString(), expectedValue);
      }
    }

    test("Invalid decimal values not accepted",
        () => _initializer("12345", true));
    test("Invalid hex values not accepted", () => _initializer("bad", true));

    test("Invalid random values not accepted",
        () => _initializer("thequickbrown", true));

    test("Invalid decimal and hex values not accepted",
        () => _initializer("12345", true));

    test("Default Guid is allowed",
        () => _initializer("00000000-0000-0000-0000-000000000000", false));

    test("Valid Guid is allowed",
        () => _initializer("f841928c-5393-4c6e-9b22-85de1fcf317a", false));

    test("Null is allowed", () => _initializer(null, false));

    test("Empty string is allowed", () => _initializer("", false));

    test("Get newGuid works", () {
      final guid = Guid.newGuid;
      final isValid = Guid.isValid(guid);
      expect(isValid, true);
    });
  });

  group("Guid equality and hashCode tests", () {
    test("Two Guids with same value but different case are equal", () {
      final g1 = Guid("A3F1C9E2-7B4D-4C6A-9F21-1A2B3C4D5E6F");
      final g2 = Guid("a3f1c9e2-7b4d-4c6a-9f21-1a2b3c4d5e6f");

      expect(g1 == g2, true, reason: "Equality should be case-insensitive");
      expect(g1.hashCode, g2.hashCode,
          reason: "HashCodes must match for equal objects");
    });

    test("Two Guids with different values are not equal", () {
      final g1 = Guid("A3F1C9E2-7B4D-4C6A-9F21-1A2B3C4D5E6F");
      final g2 = Guid("B4F1C9E2-7B4D-4C6A-9F21-1A2B3C4D5E6F");

      expect(g1 == g2, false);
      expect(g1.hashCode == g2.hashCode, false);
    });

    test("Guid works correctly in a Set", () {
      // Same value, different case
      final g1 = Guid("A3F1C9E2-7B4D-4C6A-9F21-1A2B3C4D5E6F");
      final g2 = Guid("a3f1c9e2-7b4d-4c6a-9f21-1a2b3c4d5e6f");

      final set = {g1};
      expect(set.contains(g2), true,
          reason: "Set should treat equivalent Guids as the same entry");
      expect(set.length, 1);
    });

    test("Guid does not equal non-Guid objects", () {
      final g = Guid("A3F1C9E2-7B4D-4C6A-9F21-1A2B3C4D5E6F");

      expect(g == "A3F1C9E2-7B4D-4C6A-9F21-1A2B3C4D5E6F", false);
      // ignore: unnecessary_null_comparison
      expect(g == null, false);
    });
  });
}
