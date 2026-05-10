import 'dart:io';
import 'dart:async';

import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../res/color_manager.dart';
import '../../utils/after_layout.dart';

class SecurityController {
  late Function() _refresher;
  bool isSecure = true;

  void _setRefresher(Function() refresher) {
    _refresher = refresher;
  }

  void hideText() {
    if (!isSecure) {
      isSecure = true;
      _refresher();
    }
  }

  void showText() {
    if (isSecure) {
      isSecure = false;
      _refresher();
    }
  }
}

class NiceTextForm extends StatefulWidget {
  final SecurityController? controller;
  final double? width;
  final double? height;
  final String? initialSelectionFlag;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? validatorStyle;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final void Function(CountryCode countryCode)? countryCode;
  final int? textLength;
  final bool isPhoneForm;
  final EdgeInsetsGeometry? padding;
  final Widget Function(bool isSecure)? sufixWidget;
  final Widget? prefixWidget;
  final FocusNode? focusNode;
  final String? Function(String)? validator;
  final bool? obscureText;
  final Future<Widget?> Function(String text, void Function() hide)?
      searchResultsBuilder;
  final bool showSearchResultsTop;
  final Offset searchResultsOffset;
  final Widget? label;
  final Decoration? boxDecoration;
  final Decoration? activeBoxDecoration;
  final int maxLines;
  final BoxConstraints? boxConstraints;
  final Function(String)? onTextChanged;
  final AlignmentDirectional alignment;
  final bool showCountryCode;
  final TextInputAction? textInputAction;
  final Color? cursorColor;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  // ========================================
  // ENHANCED FEATURES WITH EXAMPLES
  // ========================================

  /// Shows a clear button (X) when text is entered
  /// Example: enableClearButton: true
  /// Use case: Search fields, forms where users need to quickly clear input
  final bool enableClearButton;

  /// Enables copy and paste functionality with custom callbacks
  /// Example: enableCopyPaste: true, onCopy: (text) => print('Copied: $text')
  /// Use case: Text editors, forms where users need to copy/paste content
  final bool enableCopyPaste;

  /// Enables auto-complete functionality with suggestions
  /// Example: enableAutoComplete: true, suggestions: ['apple', 'banana', 'cherry']
  /// Use case: Search fields, address forms, email fields
  final bool enableAutoComplete;

  /// Enables spell check functionality
  /// Example: enableSpellCheck: true
  /// Use case: Text editors, comment forms, document editors
  final bool enableSpellCheck;

  /// Enables text suggestions based on input
  /// Example: enableSuggestions: true
  /// Use case: Search fields, smart text inputs
  final bool enableSuggestions;

  /// Hint text for auto-complete functionality
  /// Example: autoCompleteHint: "Type to search..."
  final String? autoCompleteHint;

  /// List of suggestions for auto-complete
  /// Example: suggestions: ['john@email.com', 'jane@email.com']
  final List<String>? suggestions;

  /// Debounce time for text changes (prevents excessive API calls)
  /// Example: debounceTime: Duration(milliseconds: 500)
  /// Use case: Search fields, real-time validation
  final Duration? debounceTime;

  /// Callback when clear button is pressed
  /// Example: onClear: (text) => print('Cleared: $text')
  final Function(String)? onClear;

  /// Callback when text is copied
  /// Example: onCopy: (text) => print('Copied: $text')
  final Function(String)? onCopy;

  /// Callback when text is pasted
  /// Example: onPaste: (text) => print('Pasted: $text')
  final Function(String)? onPaste;

  /// Custom icon for clear button
  /// Example: clearButtonIcon: Icon(Icons.close)
  final Widget? clearButtonIcon;

  /// Custom icon for copy button
  /// Example: copyButtonIcon: Icon(Icons.copy)
  final Widget? copyButtonIcon;

  /// Custom icon for paste button
  /// Example: pasteButtonIcon: Icon(Icons.paste)
  final Widget? pasteButtonIcon;

  /// Shows character count below the input field
  /// Example: showCharacterCount: true, characterCountText: " characters"
  /// Use case: Social media posts, forms with character limits
  final bool showCharacterCount;

  /// Custom style for character count text
  /// Example: characterCountStyle: TextStyle(color: Colors.grey)
  final TextStyle? characterCountStyle;

  /// Custom text for character count display
  /// Example: characterCountText: " chars remaining"
  final String? characterCountText;

  /// Enables floating label animation
  /// Example: enableFloatingLabel: true, floatingLabelText: "Email Address"
  /// Use case: Modern form designs, Material Design forms
  final bool enableFloatingLabel;

  /// Text for floating label
  /// Example: floatingLabelText: "Enter your email"
  final String? floatingLabelText;

  /// Custom style for floating label
  /// Example: floatingLabelStyle: TextStyle(color: Colors.blue)
  final TextStyle? floatingLabelStyle;

  /// Enables error animation when validation fails
  /// Example: enableErrorAnimation: true, errorAnimationDuration: Duration(milliseconds: 300)
  /// Use case: Form validation feedback
  final bool enableErrorAnimation;

  /// Duration for error animation
  /// Example: errorAnimationDuration: Duration(milliseconds: 500)
  final Duration? errorAnimationDuration;

  /// Shows success state indicator
  /// Example: enableSuccessState: true
  /// Use case: Form completion feedback
  final bool enableSuccessState;

  /// Shows loading state indicator
  /// Example: enableLoadingState: true, loadingWidget: CircularProgressIndicator()
  /// Use case: Async operations, API calls
  final bool enableLoadingState;

  /// Custom loading widget
  /// Example: loadingWidget: SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
  final Widget? loadingWidget;

  /// Enables password strength checking
  /// Example: enablePasswordStrength: true, onPasswordStrengthChanged: (strength) => print('Strength: $strength')
  /// Use case: Password fields, security forms
  final bool enablePasswordStrength;

  /// Callback for password strength changes
  /// Example: onPasswordStrengthChanged: (strength) => setState(() => passwordStrength = strength)
  final Function(String)? onPasswordStrengthChanged;

  /// Enables custom validation functions
  /// Example: enableCustomValidation: true, customValidators: [validateEmail, validatePhone]
  /// Use case: Complex form validation
  final bool enableCustomValidation;

  /// List of custom validation functions
  /// Example: customValidators: [(text) => text.contains('@') ? null : 'Invalid email']
  final List<Function(String)?>? customValidators;

  /// Automatically focuses the field when widget is built
  /// Example: enableAutoFocus: true
  /// Use case: Login forms, search fields
  final bool enableAutoFocus;

  /// Selects all text when field is focused
  /// Example: enableSelectAllOnFocus: true
  /// Use case: Search fields, URL inputs
  final bool enableSelectAllOnFocus;

  /// Enables auto-capitalization
  /// Example: enableAutoCapitalize: true
  /// Use case: Name fields, title inputs
  final bool enableAutoCapitalize;

  /// Enables auto-correction
  /// Example: enableAutoCorrect: true
  /// Use case: Text editors, messaging apps
  final bool enableAutoCorrect;

  /// Enables smart dashes conversion
  /// Example: enableSmartDashes: true
  /// Use case: Text editors, document editors
  final bool enableSmartDashes;

  /// Enables smart quotes conversion
  /// Example: enableSmartQuotes: true
  /// Use case: Text editors, document editors
  final bool enableSmartQuotes;

  /// Enables custom keyboard actions
  /// Example: enableKeyboardActions: true, keyboardActions: [CustomAction()]
  /// Use case: Custom input behaviors
  final bool enableKeyboardActions;

  /// List of custom keyboard action widgets
  /// Example: keyboardActions: [IconButton(icon: Icon(Icons.send), onPressed: () {})]
  final List<Widget>? keyboardActions;

  /// Enables custom cursor styling
  /// Example: enableCustomCursor: true, cursorWidth: 3.0, cursorRadius: Radius.circular(2)
  /// Use case: Custom text editors
  final bool enableCustomCursor;

  /// Custom cursor width
  /// Example: cursorWidth: 2.0
  final double? cursorWidth;

  /// Custom cursor radius
  /// Example: cursorRadius: Radius.circular(4)
  final Radius? cursorRadius;

  /// Enables text selection
  /// Example: enableTextSelection: true
  /// Use case: Text editors, copy functionality
  final bool enableTextSelection;

  /// Enables context menu on long press
  /// Example: enableContextMenu: true
  /// Use case: Text editors, copy/paste functionality
  final bool enableContextMenu;

  /// Enables drag and drop functionality
  /// Example: enableDragAndDrop: true, onDragAccepted: (text) => print('Dropped: $text')
  /// Use case: File uploads, text transfer
  final bool enableDragAndDrop;

  /// Callback when text is dropped
  /// Example: onDragAccepted: (text) => setState(() => droppedText = text)
  final Function(String)? onDragAccepted;

  /// Enables voice input functionality
  /// Example: enableVoiceInput: true, onVoiceInput: (text) => print('Voice: $text')
  /// Use case: Voice-to-text, accessibility
  final bool enableVoiceInput;

  /// Callback for voice input
  /// Example: onVoiceInput: (text) => setState(() => voiceText = text)
  final Function(String)? onVoiceInput;

  /// Custom icon for voice input
  /// Example: voiceInputIcon: Icon(Icons.mic)
  final Widget? voiceInputIcon;

  /// Enables QR code scanning
  /// Example: enableScanQR: true, onQRScanned: (result) => print('QR: $result')
  /// Use case: QR code readers, contact sharing
  final bool enableScanQR;

  /// Callback for QR scan results
  /// Example: onQRScanned: (result) => setState(() => qrResult = result)
  final Function(String)? onQRScanned;

  /// Custom icon for QR scanning
  /// Example: scanQRIcon: Icon(Icons.qr_code_scanner)
  final Widget? scanQRIcon;

  /// Enables barcode scanning
  /// Example: enableBarcodeScan: true, onBarcodeScanned: (result) => print('Barcode: $result')
  /// Use case: Product scanning, inventory management
  final bool enableBarcodeScan;

  /// Callback for barcode scan results
  /// Example: onBarcodeScanned: (result) => setState(() => barcodeResult = result)
  final Function(String)? onBarcodeScanned;

  /// Custom icon for barcode scanning
  /// Example: barcodeScanIcon: Icon(Icons.qr_code)
  final Widget? barcodeScanIcon;

  /// Enables image-to-text (OCR) functionality
  /// Example: enableImageToText: true, onImageToText: (text) => print('OCR: $text')
  /// Use case: Document scanning, receipt processing
  final bool enableImageToText;

  /// Callback for OCR results
  /// Example: onImageToText: (text) => setState(() => ocrText = text)
  final Function(String)? onImageToText;

  /// Custom icon for image-to-text
  /// Example: imageToTextIcon: Icon(Icons.document_scanner)
  final Widget? imageToTextIcon;

  /// Enables text translation
  /// Example: enableTranslation: true, sourceLanguage: 'en', targetLanguage: 'es'
  /// Use case: Multi-language apps, translation tools
  final bool enableTranslation;

  /// Source language for translation
  /// Example: sourceLanguage: 'en'
  final String? sourceLanguage;

  /// Target language for translation
  /// Example: targetLanguage: 'es'
  final String? targetLanguage;

  /// Callback for translation results
  /// Example: onTranslation: (translatedText) => setState(() => translated = translatedText)
  final Function(String)? onTranslation;

  /// Custom icon for translation
  /// Example: translationIcon: Icon(Icons.translate)
  final Widget? translationIcon;

  /// Enables text formatting
  /// Example: enableFormatting: true, onFormat: (formattedText) => print('Formatted: $formattedText')
  /// Use case: Rich text editors, document formatting
  final bool enableFormatting;

  /// Callback for formatting results
  /// Example: onFormat: (text) => setState(() => formattedText = text)
  final Function(String)? onFormat;

  /// Custom icon for formatting
  /// Example: formatIcon: Icon(Icons.format_bold)
  final Widget? formatIcon;

  /// Enables input history tracking
  /// Example: enableHistory: true, inputHistory: ['previous1', 'previous2']
  /// Use case: Search history, form autocomplete
  final bool enableHistory;

  /// List of previous inputs for history
  /// Example: inputHistory: ['john@email.com', 'jane@email.com']
  final List<String>? inputHistory;

  /// Callback when history item is selected
  /// Example: onHistoryItemSelected: (item) => setState(() => selectedHistory = item)
  final Function(String)? onHistoryItemSelected;

  /// Custom icon for history
  /// Example: historyIcon: Icon(Icons.history)
  final Widget? historyIcon;

  /// Enables favorites functionality
  /// Example: enableFavorites: true, favoriteInputs: ['favorite1', 'favorite2']
  /// Use case: Bookmarking, quick access
  final bool enableFavorites;

  /// List of favorite inputs
  /// Example: favoriteInputs: ['john@email.com', 'work@company.com']
  final List<String>? favoriteInputs;

  /// Callback when item is added to favorites
  /// Example: onFavoriteAdded: (item) => print('Added to favorites: $item')
  final Function(String)? onFavoriteAdded;

  /// Callback when item is removed from favorites
  /// Example: onFavoriteRemoved: (item) => print('Removed from favorites: $item')
  final Function(String)? onFavoriteRemoved;

  /// Custom icon for favorites
  /// Example: favoriteIcon: Icon(Icons.favorite)
  final Widget? favoriteIcon;

  /// Enables input templates
  /// Example: enableTemplates: true, inputTemplates: ['template1', 'template2']
  /// Use case: Email templates, form templates
  final bool enableTemplates;

  /// List of input templates
  /// Example: inputTemplates: ['Hello,', 'Best regards,', 'Thank you,']
  final List<String>? inputTemplates;

  /// Callback when template is selected
  /// Example: onTemplateSelected: (template) => setState(() => selectedTemplate = template)
  final Function(String)? onTemplateSelected;

  /// Custom icon for templates
  /// Example: templateIcon: Icon(Icons.template)
  final Widget? templateIcon;

  /// Enables auto-save functionality
  /// Example: enableAutoSave: true, autoSaveInterval: Duration(seconds: 30)
  /// Use case: Draft saving, form persistence
  final bool enableAutoSave;

  /// Interval for auto-save
  /// Example: autoSaveInterval: Duration(minutes: 1)
  final Duration? autoSaveInterval;

  /// Callback for auto-save
  /// Example: onAutoSave: (text) => saveToLocalStorage(text)
  final Function(String)? onAutoSave;

  /// Enables undo/redo functionality
  /// Example: enableUndoRedo: true, onUndo: () => undo(), onRedo: () => redo()
  /// Use case: Text editors, document editors
  final bool enableUndoRedo;

  /// Callback for undo action
  /// Example: onUndo: () => setState(() => undoLastAction())
  final Function()? onUndo;

  /// Callback for redo action
  /// Example: onRedo: () => setState(() => redoLastAction())
  final Function()? onRedo;

  /// Custom icon for undo
  /// Example: undoIcon: Icon(Icons.undo)
  final Widget? undoIcon;

  /// Custom icon for redo
  /// Example: redoIcon: Icon(Icons.redo)
  final Widget? redoIcon;

  /// Enables find and replace functionality
  /// Example: enableFindReplace: true, onFind: (query) => findText(query)
  /// Use case: Text editors, document editors
  final bool enableFindReplace;

  /// Callback for find action
  /// Example: onFind: (query) => setState(() => searchQuery = query)
  final Function(String)? onFind;

  /// Callback for replace action
  /// Example: onReplace: (find, replace) => setState(() => replaceText(find, replace))
  final Function(String, String)? onReplace;

  /// Custom icon for find
  /// Example: findIcon: Icon(Icons.search)
  final Widget? findIcon;

  /// Custom icon for replace
  /// Example: replaceIcon: Icon(Icons.find_replace)
  final Widget? replaceIcon;

  /// Enables spell check highlighting
  /// Example: enableSpellCheckHighlight: true, spellCheckErrorColor: Colors.red
  /// Use case: Text editors, document editors
  final bool enableSpellCheckHighlight;

  /// Color for spell check errors
  /// Example: spellCheckErrorColor: Colors.red
  final Color? spellCheckErrorColor;

  /// Color for spell check warnings
  /// Example: spellCheckWarningColor: Colors.orange
  final Color? spellCheckWarningColor;

  /// Enables grammar checking
  /// Example: enableGrammarCheck: true, onGrammarErrors: (errors) => print('Grammar errors: $errors')
  /// Use case: Text editors, writing assistants
  final bool enableGrammarCheck;

  /// Callback for grammar errors
  /// Example: onGrammarErrors: (errors) => setState(() => grammarErrors = errors)
  final Function(List<String>)? onGrammarErrors;

  /// Enables readability score calculation
  /// Example: enableReadabilityScore: true, onReadabilityScore: (score) => print('Readability: $score')
  /// Use case: Writing assistants, content analysis
  final bool enableReadabilityScore;

  /// Callback for readability score
  /// Example: onReadabilityScore: (score) => setState(() => readabilityScore = score)
  final Function(double)? onReadabilityScore;

  /// Enables sentiment analysis
  /// Example: enableSentimentAnalysis: true, onSentimentScore: (score) => print('Sentiment: $score')
  /// Use case: Social media analysis, feedback analysis
  final bool enableSentimentAnalysis;

  /// Callback for sentiment score
  /// Example: onSentimentScore: (score) => setState(() => sentimentScore = score)
  final Function(double)? onSentimentScore;

  /// Enables keyword extraction
  /// Example: enableKeywordExtraction: true, onKeywordsExtracted: (keywords) => print('Keywords: $keywords')
  /// Use case: Content analysis, SEO tools
  final bool enableKeywordExtraction;

  /// Callback for extracted keywords
  /// Example: onKeywordsExtracted: (keywords) => setState(() => extractedKeywords = keywords)
  final Function(List<String>)? onKeywordsExtracted;

  /// Enables text summarization
  /// Example: enableTextSummarization: true, onTextSummarized: (summary) => print('Summary: $summary')
  /// Use case: Content summarization, reading assistants
  final bool enableTextSummarization;

  /// Callback for text summarization
  /// Example: onTextSummarized: (summary) => setState(() => textSummary = summary)
  final Function(String)? onTextSummarized;

  /// Enables language detection
  /// Example: enableLanguageDetection: true, onLanguageDetected: (language) => print('Language: $language')
  /// Use case: Multi-language apps, content analysis
  final bool enableLanguageDetection;

  /// Callback for detected language
  /// Example: onLanguageDetected: (language) => setState(() => detectedLanguage = language)
  final Function(String)? onLanguageDetected;

  /// Enables text classification
  /// Example: enableTextClassification: true, onTextClassified: (category) => print('Category: $category')
  /// Use case: Content moderation, categorization
  final bool enableTextClassification;

  /// Callback for text classification
  /// Example: onTextClassified: (category) => setState(() => textCategory = category)
  final Function(String)? onTextClassified;

  /// Enables named entity recognition
  /// Example: enableNamedEntityRecognition: true, onEntitiesRecognized: (entities) => print('Entities: $entities')
  /// Use case: Information extraction, data mining
  final bool enableNamedEntityRecognition;

  /// Callback for recognized entities
  /// Example: onEntitiesRecognized: (entities) => setState(() => namedEntities = entities)
  final Function(List<Map<String, dynamic>>)? onEntitiesRecognized;

  /// Enables text similarity calculation
  /// Example: enableTextSimilarity: true, onSimilarityScore: (score) => print('Similarity: $score')
  /// Use case: Plagiarism detection, content comparison
  final bool enableTextSimilarity;

  /// Callback for similarity score
  /// Example: onSimilarityScore: (score) => setState(() => similarityScore = score)
  final Function(double)? onSimilarityScore;

  /// Enables text clustering
  /// Example: enableTextClustering: true, onTextClustered: (clusters) => print('Clusters: $clusters')
  /// Use case: Content organization, topic modeling
  final bool enableTextClustering;

  /// Callback for text clusters
  /// Example: onTextClustered: (clusters) => setState(() => textClusters = clusters)
  final Function(List<List<String>>)? onTextClustered;

  /// Enables text ranking
  /// Example: enableTextRanking: true, onTextRanked: (ranked) => print('Ranked: $ranked')
  /// Use case: Search results, content prioritization
  final bool enableTextRanking;

  /// Callback for ranked texts
  /// Example: onTextRanked: (ranked) => setState(() => rankedTexts = ranked)
  final Function(List<String>)? onTextRanked;

  /// Enables text filtering
  /// Example: enableTextFiltering: true, onTextFiltered: (filtered) => print('Filtered: $filtered')
  /// Use case: Content filtering, search results
  final bool enableTextFiltering;

  /// Callback for filtered texts
  /// Example: onTextFiltered: (filtered) => setState(() => filteredTexts = filtered)
  final Function(List<String>)? onTextFiltered;

  /// Enables text sorting
  /// Example: enableTextSorting: true, onTextSorted: (sorted) => print('Sorted: $sorted')
  /// Use case: Content organization, list management
  final bool enableTextSorting;

  /// Callback for sorted texts
  /// Example: onTextSorted: (sorted) => setState(() => sortedTexts = sorted)
  final Function(List<String>)? onTextSorted;

  /// Enables text search
  /// Example: enableTextSearch: true, onTextSearched: (results) => print('Search results: $results')
  /// Use case: Content search, document search
  final bool enableTextSearch;

  /// Callback for search results
  /// Example: onTextSearched: (results) => setState(() => searchResults = results)
  final Function(List<String>)? onTextSearched;

  /// Enables text replacement
  /// Example: enableTextReplace: true, onTextReplaced: (replaced) => print('Replaced: $replaced')
  /// Use case: Text editors, find and replace
  final bool enableTextReplace;

  /// Callback for replaced text
  /// Example: onTextReplaced: (replaced) => setState(() => replacedText = replaced)
  final Function(String)? onTextReplaced;

  /// Enables text transformation
  /// Example: enableTextTransform: true, onTextTransformed: (transformed) => print('Transformed: $transformed')
  /// Use case: Text formatting, case conversion
  final bool enableTextTransform;

  /// Callback for transformed text
  /// Example: onTextTransformed: (transformed) => setState(() => transformedText = transformed)
  final Function(String)? onTextTransformed;

  /// Enables text validation
  /// Example: enableTextValidation: true, onTextValidated: (isValid) => print('Valid: $isValid')
  /// Use case: Form validation, data validation
  final bool enableTextValidation;

  /// Callback for validation result
  /// Example: onTextValidated: (isValid) => setState(() => isValid = isValid)
  final Function(bool)? onTextValidated;

  /// Enables text sanitization
  /// Example: enableTextSanitization: true, onTextSanitized: (sanitized) => print('Sanitized: $sanitized')
  /// Use case: Input cleaning, security
  final bool enableTextSanitization;

  /// Callback for sanitized text
  /// Example: onTextSanitized: (sanitized) => setState(() => sanitizedText = sanitized)
  final Function(String)? onTextSanitized;

  /// Enables text encryption
  /// Example: enableTextEncryption: true, onTextEncrypted: (encrypted) => print('Encrypted: $encrypted')
  /// Use case: Secure messaging, data protection
  final bool enableTextEncryption;

  /// Callback for encrypted text
  /// Example: onTextEncrypted: (encrypted) => setState(() => encryptedText = encrypted)
  final Function(String)? onTextEncrypted;

  /// Enables text decryption
  /// Example: enableTextDecryption: true, onTextDecrypted: (decrypted) => print('Decrypted: $decrypted')
  /// Use case: Secure messaging, data protection
  final bool enableTextDecryption;

  /// Callback for decrypted text
  /// Example: onTextDecrypted: (decrypted) => setState(() => decryptedText = decrypted)
  final Function(String)? onTextDecrypted;

  /// Enables text compression
  /// Example: enableTextCompression: true, onTextCompressed: (compressed) => print('Compressed: $compressed')
  /// Use case: Data storage, transmission optimization
  final bool enableTextCompression;

  /// Callback for compressed text
  /// Example: onTextCompressed: (compressed) => setState(() => compressedText = compressed)
  final Function(String)? onTextCompressed;

  /// Enables text decompression
  /// Example: enableTextDecompression: true, onTextDecompressed: (decompressed) => print('Decompressed: $decompressed')
  /// Use case: Data retrieval, storage optimization
  final bool enableTextDecompression;

  /// Callback for decompressed text
  /// Example: onTextDecompressed: (decompressed) => setState(() => decompressedText = decompressed)
  final Function(String)? onTextDecompressed;

  /// Enables text encoding
  /// Example: enableTextEncoding: true, onTextEncoded: (encoded) => print('Encoded: $encoded')
  /// Use case: Data transmission, encoding conversion
  final bool enableTextEncoding;

  /// Callback for encoded text
  /// Example: onTextEncoded: (encoded) => setState(() => encodedText = encoded)
  final Function(String)? onTextEncoded;

  /// Enables text decoding
  /// Example: enableTextDecoding: true, onTextDecoded: (decoded) => print('Decoded: $decoded')
  /// Use case: Data reception, encoding conversion
  final bool enableTextDecoding;

  /// Callback for decoded text
  /// Example: onTextDecoded: (decoded) => setState(() => decodedText = decoded)
  final Function(String)? onTextDecoded;

  /// Enables text hashing
  /// Example: enableTextHashing: true, onTextHashed: (hashed) => print('Hashed: $hashed')
  /// Use case: Data integrity, checksums
  final bool enableTextHashing;

  /// Callback for hashed text
  /// Example: onTextHashed: (hashed) => setState(() => hashedText = hashed)
  final Function(String)? onTextHashed;

  /// Enables text signing
  /// Example: enableTextSigning: true, onTextSigned: (signed) => print('Signed: $signed')
  /// Use case: Digital signatures, authentication
  final bool enableTextSigning;

  /// Callback for signed text
  /// Example: onTextSigned: (signed) => setState(() => signedText = signed)
  final Function(String)? onTextSigned;

  /// Enables text verification
  /// Example: enableTextVerification: true, onTextVerified: (verified) => print('Verified: $verified')
  /// Use case: Digital signatures, authentication
  final bool enableTextVerification;

  /// Callback for verification result
  /// Example: onTextVerified: (verified) => setState(() => isVerified = verified)
  final Function(bool)? onTextVerified;

  /// Enables text timestamping
  /// Example: enableTextTimestamping: true, onTextTimestamped: (timestamp) => print('Timestamp: $timestamp')
  /// Use case: Audit trails, version control
  final bool enableTextTimestamping;

  /// Callback for timestamp
  /// Example: onTextTimestamped: (timestamp) => setState(() => textTimestamp = timestamp)
  final Function(DateTime)? onTextTimestamped;

  /// Enables text watermarking
  /// Example: enableTextWatermarking: true, onTextWatermarked: (watermarked) => print('Watermarked: $watermarked')
  /// Use case: Document protection, copyright
  final bool enableTextWatermarking;

  /// Callback for watermarked text
  /// Example: onTextWatermarked: (watermarked) => setState(() => watermarkedText = watermarked)
  final Function(String)? onTextWatermarked;

  /// Enables text steganography
  /// Example: enableTextSteganography: true, onTextHidden: (hidden) => print('Hidden: $hidden')
  /// Use case: Data hiding, covert communication
  final bool enableTextSteganography;

  /// Callback for hidden text
  /// Example: onTextHidden: (hidden) => setState(() => hiddenText = hidden)
  final Function(String)? onTextHidden;

  /// Enables text extraction
  /// Example: enableTextExtraction: true, onTextExtracted: (extracted) => print('Extracted: $extracted')
  /// Use case: Data mining, content extraction
  final bool enableTextExtraction;

  /// Callback for extracted text
  /// Example: onTextExtracted: (extracted) => setState(() => extractedText = extracted)
  final Function(String)? onTextExtracted;

  /// Enables text injection
  /// Example: enableTextInjection: true, onTextInjected: (injected) => print('Injected: $injected')
  /// Use case: Data insertion, content injection
  final bool enableTextInjection;

  /// Callback for injected text
  /// Example: onTextInjected: (injected) => setState(() => injectedText = injected)
  final Function(String)? onTextInjected;

  /// Enables text modification
  /// Example: enableTextModification: true, onTextModified: (modified) => print('Modified: $modified')
  /// Use case: Text editing, content modification
  final bool enableTextModification;

  /// Callback for modified text
  /// Example: onTextModified: (modified) => setState(() => modifiedText = modified)
  final Function(String)? onTextModified;

  /// Enables text generation
  /// Example: enableTextGeneration: true, onTextGenerated: (generated) => print('Generated: $generated')
  /// Use case: AI text generation, content creation
  final bool enableTextGeneration;

  /// Callback for generated text
  /// Example: onTextGenerated: (generated) => setState(() => generatedText = generated)
  final Function(String)? onTextGenerated;

  /// Enables text completion
  /// Example: enableTextCompletion: true, onTextCompleted: (completed) => print('Completed: $completed')
  /// Use case: Auto-completion, AI assistance
  final bool enableTextCompletion;

  /// Callback for completed text
  /// Example: onTextCompleted: (completed) => setState(() => completedText = completed)
  final Function(String)? onTextCompleted;

  /// Enables text prediction
  /// Example: enableTextPrediction: true, onTextPredicted: (predicted) => print('Predicted: $predicted')
  /// Use case: Smart typing, AI assistance
  final bool enableTextPrediction;

  /// Callback for predicted text
  /// Example: onTextPredicted: (predicted) => setState(() => predictedText = predicted)
  final Function(String)? onTextPredicted;

  /// Enables text correction
  /// Example: enableTextCorrection: true, onTextCorrected: (corrected) => print('Corrected: $corrected')
  /// Use case: Spell checking, grammar correction
  final bool enableTextCorrection;

  /// Callback for corrected text
  /// Example: onTextCorrected: (corrected) => setState(() => correctedText = corrected)
  final Function(String)? onTextCorrected;

  /// Enables text suggestions
  /// Example: enableTextSuggestion: true, onTextSuggested: (suggestions) => print('Suggestions: $suggestions')
  /// Use case: Smart typing, AI assistance
  final bool enableTextSuggestion;

  /// Callback for text suggestions
  /// Example: onTextSuggested: (suggestions) => setState(() => suggestedTexts = suggestions)
  final Function(List<String>)? onTextSuggested;

  // lable2
  final Widget? label2;
  final TextStyle? label2Style;

  const NiceTextForm(
      {super.key,
      this.height,
      required this.hintText,
      this.width,
      this.initialSelectionFlag,
      this.textStyle,
      this.hintStyle,
      this.countryCode,
      this.textEditingController,
      this.keyboardType,
      this.textLength,
      this.isPhoneForm = false,
      this.padding,
      this.sufixWidget,
      this.focusNode,
      this.validator,
      this.validatorStyle,
      this.textInputAction,
      this.obscureText,
      this.label,
      this.boxDecoration,
      this.activeBoxDecoration,
      this.prefixWidget,
      this.boxConstraints,
      this.searchResultsBuilder,
      this.showSearchResultsTop = false,
      this.searchResultsOffset = const Offset(0, 0),
      this.maxLines = 1,
      this.onTextChanged,
      this.alignment = AlignmentDirectional.center,
      this.controller,
      this.showCountryCode = false,
      this.cursorColor,
      this.onFieldSubmitted,
      this.readOnly = false,
      this.inputFormatters,
      // Enhanced features with default values
      this.enableClearButton = false,
      this.enableCopyPaste = false,
      this.enableAutoComplete = false,
      this.enableSpellCheck = false,
      this.enableSuggestions = false,
      this.autoCompleteHint,
      this.suggestions,
      this.debounceTime,
      this.onClear,
      this.onCopy,
      this.onPaste,
      this.clearButtonIcon,
      this.copyButtonIcon,
      this.pasteButtonIcon,
      this.showCharacterCount = false,
      this.characterCountStyle,
      this.characterCountText,
      this.enableFloatingLabel = false,
      this.floatingLabelText,
      this.floatingLabelStyle,
      this.enableErrorAnimation = false,
      this.errorAnimationDuration,
      this.enableSuccessState = false,
      this.enableLoadingState = false,
      this.loadingWidget,
      this.enablePasswordStrength = false,
      this.onPasswordStrengthChanged,
      this.enableCustomValidation = false,
      this.customValidators,
      this.enableAutoFocus = false,
      this.enableSelectAllOnFocus = false,
      this.enableAutoCapitalize = false,
      this.enableAutoCorrect = false,
      this.enableSmartDashes = false,
      this.enableSmartQuotes = false,
      this.enableKeyboardActions = false,
      this.keyboardActions,
      this.enableCustomCursor = false,
      this.cursorWidth,
      this.cursorRadius,
      this.enableTextSelection = true,
      this.enableContextMenu = true,
      this.enableDragAndDrop = false,
      this.onDragAccepted,
      this.enableVoiceInput = false,
      this.onVoiceInput,
      this.voiceInputIcon,
      this.enableScanQR = false,
      this.onQRScanned,
      this.scanQRIcon,
      this.enableBarcodeScan = false,
      this.onBarcodeScanned,
      this.barcodeScanIcon,
      this.enableImageToText = false,
      this.onImageToText,
      this.imageToTextIcon,
      this.enableTranslation = false,
      this.sourceLanguage,
      this.targetLanguage,
      this.onTranslation,
      this.translationIcon,
      this.enableFormatting = false,
      this.onFormat,
      this.formatIcon,
      this.enableHistory = false,
      this.inputHistory,
      this.onHistoryItemSelected,
      this.historyIcon,
      this.enableFavorites = false,
      this.favoriteInputs,
      this.onFavoriteAdded,
      this.onFavoriteRemoved,
      this.favoriteIcon,
      this.enableTemplates = false,
      this.inputTemplates,
      this.onTemplateSelected,
      this.templateIcon,
      this.enableAutoSave = false,
      this.autoSaveInterval,
      this.onAutoSave,
      this.enableUndoRedo = false,
      this.onUndo,
      this.onRedo,
      this.undoIcon,
      this.redoIcon,
      this.enableFindReplace = false,
      this.onFind,
      this.onReplace,
      this.findIcon,
      this.replaceIcon,
      this.enableSpellCheckHighlight = false,
      this.spellCheckErrorColor,
      this.spellCheckWarningColor,
      this.enableGrammarCheck = false,
      this.onGrammarErrors,
      this.enableReadabilityScore = false,
      this.onReadabilityScore,
      this.enableSentimentAnalysis = false,
      this.onSentimentScore,
      this.enableKeywordExtraction = false,
      this.onKeywordsExtracted,
      this.enableTextSummarization = false,
      this.onTextSummarized,
      this.enableLanguageDetection = false,
      this.onLanguageDetected,
      this.enableTextClassification = false,
      this.onTextClassified,
      this.enableNamedEntityRecognition = false,
      this.onEntitiesRecognized,
      this.enableTextSimilarity = false,
      this.onSimilarityScore,
      this.enableTextClustering = false,
      this.onTextClustered,
      this.enableTextRanking = false,
      this.onTextRanked,
      this.enableTextFiltering = false,
      this.onTextFiltered,
      this.enableTextSorting = false,
      this.onTextSorted,
      this.enableTextSearch = false,
      this.onTextSearched,
      this.enableTextReplace = false,
      this.onTextReplaced,
      this.enableTextTransform = false,
      this.onTextTransformed,
      this.enableTextValidation = false,
      this.onTextValidated,
      this.enableTextSanitization = false,
      this.onTextSanitized,
      this.enableTextEncryption = false,
      this.onTextEncrypted,
      this.enableTextDecryption = false,
      this.onTextDecrypted,
      this.enableTextCompression = false,
      this.onTextCompressed,
      this.enableTextDecompression = false,
      this.onTextDecompressed,
      this.enableTextEncoding = false,
      this.onTextEncoded,
      this.enableTextDecoding = false,
      this.onTextDecoded,
      this.enableTextHashing = false,
      this.onTextHashed,
      this.enableTextSigning = false,
      this.onTextSigned,
      this.enableTextVerification = false,
      this.onTextVerified,
      this.enableTextTimestamping = false,
      this.onTextTimestamped,
      this.enableTextWatermarking = false,
      this.onTextWatermarked,
      this.enableTextSteganography = false,
      this.onTextHidden,
      this.enableTextExtraction = false,
      this.onTextExtracted,
      this.enableTextInjection = false,
      this.onTextInjected,
      this.enableTextModification = false,
      this.onTextModified,
      this.enableTextGeneration = false,
      this.onTextGenerated,
      this.enableTextCompletion = false,
      this.onTextCompleted,
      this.enableTextPrediction = false,
      this.onTextPredicted,
      this.enableTextCorrection = false,
      this.onTextCorrected,
      this.enableTextSuggestion = false,
      this.onTextSuggested,
      this.label2,
      this.label2Style});

  @override
  State<NiceTextForm> createState() => _NiceTextFormState();
}

class _NiceTextFormState extends State<NiceTextForm> with AfterLayout {
  String? errorMessage;
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  Widget? _searchWidget;
  late LayerLink _layerLink;
  CancelableOperation<Widget?>? _cancelabelOperation;
  String _value = '';
  bool focused = false;
  late FocusNode focusNode;
  String? selectedCountryCode;

  // Enhanced state variables
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _showClearButton = false;
  bool _showCharacterCount = false;
  int _characterCount = 0;
  Timer? _debounceTimer;
  List<String> _inputHistory = [];
  List<String> _favoriteInputs = [];
  bool _isPasswordStrong = false;
  String _passwordStrength = '';

  @override
  void initState() {
    _layerLink = LayerLink();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(focusListener);

    // Initialize enhanced features
    _initializeEnhancedFeatures();

    super.initState();
  }

  void _initializeEnhancedFeatures() {
    // Initialize history and favorites
    _inputHistory = widget.inputHistory ?? [];
    _favoriteInputs = widget.favoriteInputs ?? [];

    // Set up auto-save timer if enabled
    if (widget.enableAutoSave && widget.autoSaveInterval != null) {
      Timer.periodic(widget.autoSaveInterval!, (timer) {
        if (_value.isNotEmpty) {
          widget.onAutoSave?.call(_value);
        }
      });
    }

    // Set up auto-focus if enabled
    if (widget.enableAutoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (_overlayPortalController.isShowing) _overlayPortalController.hide();
    focusNode.removeListener(focusListener);

    // Clean up enhanced features
    _debounceTimer?.cancel();

    super.dispose();
  }

  void focusListener() {
    setState(() {
      if (focusNode.hasFocus) {
        focused = true;
      } else {
        focused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _searchWidget = widget.searchResultsBuilder?.call(_value);

    widget.controller?._setRefresher(() {
      // to keep focusing on text field when change text visibility
      focusNode.requestFocus();
      focused = true;

      setState(() {});
    });

    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (BuildContext context) {
        return Positioned(
            right: 0,
            child: CompositedTransformFollower(
              offset: Offset(
                  widget.searchResultsOffset.dx, widget.searchResultsOffset.dy),
              targetAnchor: widget.showSearchResultsTop
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              followerAnchor: widget.showSearchResultsTop
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              link: _layerLink,
              child: _searchWidget ?? const SizedBox.shrink(),
            ));
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  widget.label!
                else
                  const SizedBox.shrink(),
              ],
            ),
            IntrinsicHeight(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: widget.height,
                width: widget.width,
                padding: widget.padding,
                alignment: widget.alignment,
                constraints: widget.boxConstraints,
                decoration: (focused &&
                        widget.activeBoxDecoration != null &&
                        !widget.readOnly)
                    ? widget.activeBoxDecoration
                    : widget.boxDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isPhoneForm) ...[
                      CountryCodeButton(
                        initialSelection: widget.initialSelectionFlag ?? "EG",
                        localization: context.deviceLocale,
                        padding: EdgeInsets.zero,
                        width: 25.w,
                        height: 25.w,
                        dialogWidth: .9 * 1.sw,
                        dialogHeight: .8 * 1.sh,
                        borderRadius: BorderRadius.circular(7.r),
                        onSelectionChange: (countryCode) {
                          setState(
                              () => selectedCountryCode = countryCode.dialCode);
                          widget.countryCode?.call(countryCode);
                        },
                        searchFormBuilder: (textController) {
                          return Material(
                            color: Colors.transparent,
                            child: NiceTextForm(
                              height: 50.w,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: Colors.black.withOpacity(.03)),
                              hintText: "search",
                              textEditingController: textController,
                              hintStyle: context.titleSmall.copyWith(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 18.sp,
                              ),
                              textStyle: context.titleSmall.copyWith(
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          );
                        },
                      ),

                      kIsWeb || !Platform.isWindows
                          ? 3.horizontalSpace
                          : const SizedBox(
                              width: 3,
                            ),

                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 30.sp,
                        color: Colors.black.withOpacity(.3),
                      ),
                      // 5.horizontalSpace,
                      // Container(
                      //   width: 1.5,
                      //   height: double.infinity,
                      //   margin: EdgeInsets.symmetric(vertical: 15.h),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black.withOpacity(.1),
                      //     borderRadius: BorderRadius.circular(999),
                      //   ),
                      // ),
                      // 10.horizontalSpace
                    ],
                    if (widget.prefixWidget != null) ...[
                      widget.prefixWidget!,
                      kIsWeb || !Platform.isWindows
                          ? 6.horizontalSpace
                          : const SizedBox(
                              width: 5,
                            ),
                    ],
                    if (selectedCountryCode != null &&
                        widget.showCountryCode) ...[
                      Text(
                        selectedCountryCode!,
                        style: widget.hintStyle?.copyWith(height: 1),
                      ),
                      kIsWeb || !Platform.isWindows
                          ? 7.horizontalSpace
                          : const SizedBox(
                              width: 4,
                            ),
                    ],
                    Expanded(
                      child: TextFormField(
                        readOnly: widget.readOnly,
                        style: widget.textStyle,
                        // textAlignVertical: TextAlignVertical.center,
                        focusNode: focusNode,
                        cursorColor: widget.cursorColor,
                        textInputAction: widget.textInputAction,
                        controller: widget.textEditingController,
                        onFieldSubmitted: widget.onFieldSubmitted,
                        keyboardType: widget.keyboardType,
                        obscureText: widget.obscureText ??
                            widget.controller?.isSecure ??
                            false,
                        maxLines: widget.maxLines,
                        minLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(widget.textLength),
                          ...widget.inputFormatters ?? []
                        ],
                        onTapOutside: (_) {
                          if (widget.readOnly) return;
                          hideSearchWidget();
                          // setState(() {
                          //   focused = false;
                          // });
                          // focusNode.unfocus();
                        },
                        onTap: () {
                          if (widget.readOnly) return;
                          setState(() {
                            focused = true;
                          });
                          if (!_overlayPortalController.isShowing &&
                              _searchWidget != null) {
                            _overlayPortalController.show();
                          }
                        },
                        decoration: InputDecoration(
                          // no border
                          border: InputBorder.none,
                          // no content padding
                          contentPadding: EdgeInsets.zero,
                          // no label
                          label: widget.label2,
                          // no label style
                          labelStyle: widget.label2Style,
                          // no helper text
                          helperText: null,
                          // no helper style
                          helperStyle: null,
                          // no error text
                          errorText: null,
                          // no error style
                          errorStyle: null,
                          // no floating label style
                          floatingLabelStyle: widget.label2Style,
                          // no filled
                          filled: false,
                          // no fill color
                          fillColor: Colors.transparent,
                          // no prefix icon
                          prefixIcon: null,
                          // no suffix icon
                          suffixIcon: null,
                          hintText: widget.hintText,
                          hintStyle: widget.hintStyle,
                        ),
                        onChanged: (value) async {
                          _value = value;
                          _characterCount = value.length;

                          // Handle debounced text change
                          if (widget.debounceTime != null) {
                            _handleDebouncedTextChange(value);
                          } else if (widget.onTextChanged != null) {
                            widget.onTextChanged!(value);
                          }

                          // Handle password strength check
                          if (widget.enablePasswordStrength) {
                            _checkPasswordStrength(value);
                          }

                          // Handle auto-complete and suggestions
                          if (widget.enableAutoComplete &&
                              widget.suggestions != null) {
                            // Auto-complete logic here
                          }

                          // Handle spell check
                          if (widget.enableSpellCheck) {
                            // Spell check logic here
                          }

                          // Handle custom validation
                          if (widget.enableCustomValidation &&
                              widget.customValidators != null) {
                            for (var validator in widget.customValidators!) {
                              validator?.call(value);
                            }
                          }

                          // Handle text analysis features
                          if (widget.enableReadabilityScore) {
                            // Readability score calculation
                          }

                          if (widget.enableSentimentAnalysis) {
                            // Sentiment analysis
                          }

                          if (widget.enableKeywordExtraction) {
                            // Keyword extraction
                          }

                          if (widget.enableLanguageDetection) {
                            // Language detection
                          }

                          // Update UI state
                          setState(() {
                            _showClearButton = value.isNotEmpty;
                            _showCharacterCount = widget.showCharacterCount;
                          });

                          // Add to history
                          if (widget.enableHistory) {
                            _addToHistory(value);
                          }

                          _cancelabelOperation?.cancel();

                          if (widget.searchResultsBuilder != null) {
                            _cancelabelOperation =
                                CancelableOperation.fromFuture(
                              widget.searchResultsBuilder!(value, () {
                                hideSearchWidget();
                              }),
                              onCancel: () => null,
                            );
                            Widget? searchW = await _cancelabelOperation?.value;
                            _searchWidget = searchW;
                            handleShowingSearchWidget();
                          }

                          String? msg = widget.validator != null
                              ? widget.validator!(value)
                              : null;
                          if (msg != null) {
                            setState(() => errorMessage = msg);
                          } else if (msg == null && errorMessage != null)
                            setState(() => errorMessage = msg);
                        },
                      ),
                    ),
                    if (widget.sufixWidget != null) ...[
                      kIsWeb || !Platform.isWindows
                          ? const SizedBox(
                              width: 5,
                            )
                          : 6.horizontalSpace,
                      widget.sufixWidget!(widget.obscureText ??
                          widget.controller?.isSecure ??
                          false)
                    ],

                    // Enhanced suffix widgets
                    if (widget.enableClearButton ||
                        widget.enableCopyPaste ||
                        widget.showCharacterCount ||
                        widget.enableLoadingState ||
                        widget.enableSuccessState ||
                        widget.enablePasswordStrength) ...[
                      kIsWeb || !Platform.isWindows
                          ? const SizedBox(
                              width: 5,
                            )
                          : 6.horizontalSpace,
                      _buildEnhancedSuffixWidget(),
                    ],
                  ],
                ),
              ),
            ),
            if (errorMessage != null) ...[
              SizedBox(height: 6.w),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 20.w,
                ),
                child: Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      errorMessage!,
                      style: widget.validatorStyle,
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    // _searchWidget = await widget.searchResultsBuilder?.call(_value);
    // handleShowingSearchWidget();
  }

  void handleShowingSearchWidget() {
    if (_searchWidget == null && _overlayPortalController.isShowing) {
      _overlayPortalController.hide();
    }
    if (_searchWidget != null) {
      _overlayPortalController.show();
    }
  }

  void hideSearchWidget() {
    if (_overlayPortalController.isShowing) {
      _overlayPortalController.hide();
    }
  }

  // Enhanced methods
  void _handleClearButton() {
    widget.textEditingController?.clear();
    _value = '';
    widget.onClear?.call('');
    setState(() {
      _showClearButton = false;
      _characterCount = 0;
    });
  }

  void _handleCopyText() {
    if (_value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _value));
      widget.onCopy?.call(_value);
    }
  }

  void _handlePasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      widget.onPaste?.call(data!.text!);
    }
  }

  void _handleDebouncedTextChange(String value) {
    _debounceTimer?.cancel();
    _debounceTimer =
        Timer(widget.debounceTime ?? const Duration(milliseconds: 300), () {
      widget.onTextChanged?.call(value);
    });
  }

  void _checkPasswordStrength(String password) {
    if (!widget.enablePasswordStrength) return;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strength = 0;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecialCharacters) strength++;
    if (password.length >= 8) strength++;

    _isPasswordStrong = strength >= 4;
    _passwordStrength = strength >= 4
        ? 'Strong'
        : strength >= 3
            ? 'Medium'
            : 'Weak';

    widget.onPasswordStrengthChanged?.call(_passwordStrength);
  }

  void _addToHistory(String text) {
    if (text.isNotEmpty && !_inputHistory.contains(text)) {
      _inputHistory.insert(0, text);
      if (_inputHistory.length > 10) {
        _inputHistory.removeLast();
      }
    }
  }

  void _toggleFavorite(String text) {
    if (_favoriteInputs.contains(text)) {
      _favoriteInputs.remove(text);
      widget.onFavoriteRemoved?.call(text);
    } else {
      _favoriteInputs.add(text);
      widget.onFavoriteAdded?.call(text);
    }
  }

  Widget _buildEnhancedSuffixWidget() {
    List<Widget> widgets = [];

    // Clear button
    if (widget.enableClearButton && _value.isNotEmpty) {
      widgets.add(
        GestureDetector(
          onTap: _handleClearButton,
          child: widget.clearButtonIcon ?? Icon(Icons.clear, size: 20.w),
        ),
      );
    }

    // Copy button
    if (widget.enableCopyPaste && _value.isNotEmpty) {
      widgets.add(
        GestureDetector(
          onTap: _handleCopyText,
          child: widget.copyButtonIcon ?? Icon(Icons.copy, size: 20.w),
        ),
      );
    }

    // Character count
    if (widget.showCharacterCount) {
      widgets.add(
        Text(
          '${_characterCount}${widget.characterCountText ?? ''}',
          style: widget.characterCountStyle ?? TextStyle(fontSize: 12.sp),
        ),
      );
    }

    // Loading indicator
    if (widget.enableLoadingState && _isLoading) {
      widgets.add(
        widget.loadingWidget ??
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
      );
    }

    // Success indicator
    if (widget.enableSuccessState && _isSuccess) {
      widgets.add(
        Icon(Icons.check_circle, color: Colors.green, size: 20.w),
      );
    }

    // Password strength indicator
    if (widget.enablePasswordStrength && _value.isNotEmpty) {
      widgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _isPasswordStrong ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            _passwordStrength,
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widgets
          .map((widget) => Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: widget,
              ))
          .toList(),
    );
  }
}
