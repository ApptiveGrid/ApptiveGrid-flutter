# Script to download translations from poeditor
#
# Prerequisites:
#
# 1. Add a poeditor.properties file
# It should declare the variables:
# PE_API_TOKEN="Api Token"
# PE_PROJECT_ID="Project ID"
#
# 2. Install jq
# on MacOs using `brew install jq`
# for other operating systems check:
# https://stedolan.github.io/jq/download/
source poeditor.properties

l10nPath="../lib/translation/l10n"

declare -a defaultTranslations

# The default locale should always be the first one
# to have the fallback translations for all other locales
for lang in "en" "de"; do
  echo $lang
  command=$(curl -X POST https://api.poeditor.com/v2/projects/export \
          -d api_token="$PE_API_TOKEN" \
          -d id="$PE_PROJECT_ID" \
          -d language="$lang" \
          -d type="key_value_json" | jq -r ".result.url")
      file="${l10nPath}/intl_$lang.json"
      curl "$command" -o "$file"

      langFile="${l10nPath}/translation_$lang.dart"

      printf "// ignore_for_file: public_member_api_docs\n\n" >"$langFile"
      printf "import 'package:apptive_grid_form/apptive_grid_form.dart';\n\n" >>"$langFile"
      printf "class ApptiveGridLocalizedTranslation extends ApptiveGridTranslation {\n" >>"$langFile"
      printf "  const ApptiveGridLocalizedTranslation() : super();\n" >>"$langFile"

      keys=($(jq -r 'keys_unsorted[]' "$file"))
      values=$(jq -r 'values[]' "$file")

      SAVEIFS=$IFS # Save current IFS
      IFS=$'\n'    # Change IFS to new line

      # Populate array of values
      declare -a array
      n=0
      for line in "${values[@]}"; do
          array+=($line)
          n=$(($n + 1))
      done

      # Print keys and values to Dart class
      n=0
      for key in "${keys[@]}"; do
          printf "   @override\n" >>$langFile
          if [ -z "${array[$n]}" ]; then
            translation="${defaultTranslations[$n]}"
          else
            translation="${array[$n]}"
          fi
          if [ $key == "fieldIsRequired" ]; then
            wildcard="fieldName"
            printf "   String %s(String %s) => \"%s\";\n" $key "$wildcard" "$translation" >>$langFile
          else
            printf "   String get %s => \"%s\";\n" $key "$translation" >>$langFile
          fi
          n=$(($n + 1))
      done

      IFS=$SAVEIFS # Restore IFS

      printf "}" >>"$langFile"

      # Save the default locale translations for future use
      if [ "$lang" == "en" ]; then
        defaultTranslations=("${array[@]}")
      fi
      unset array
      unset keys
      unset values
      unset translation
      unset n
done

#dartfmt -w $l10nPath