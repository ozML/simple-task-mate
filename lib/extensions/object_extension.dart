extension ObjectExtension<T> on T {
  U mapTo<U>(U Function(T e) toElement) => toElement(this);
}
