extension ListExtensions<T> on List<T> {
  /// Maps each element along with its index
  List<E> mapWithIndex<E>(E Function(T item, int index) convert) {
    return asMap().entries.map((entry) => convert(entry.value, entry.key)).toList();
  }

  /// Maps each element with index and adds separator between items
  List<E> mapWithSeparator<E>({
    required E Function(T item) itemBuilder,
    required E Function() separatorBuilder,
    bool includeLast = false,
  }) {
    final List<E> result = [];
    asMap().forEach((index, item) {
      result.add(itemBuilder(item));
      if (includeLast ? index < length : index < length - 1) {
        result.add(separatorBuilder());
      }
    });
    return result;
  }
} 