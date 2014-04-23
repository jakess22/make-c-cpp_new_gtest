/*
 * Copyright (c) 2014, Joe Example
 */
#ifndef UTIL_LINKEDLIST_H_
#error "Do not include this .tcc file directly, use the .h file"
#else

template <typename T>
LinkedList<T>::LinkedList() : head_(NULL), count_(0) {}

template <typename T>
LinkedList<T>::~LinkedList() {
  Cell* next;
  while (head_ != NULL) {
    next = head_->next;
    delete head_;
    head_ = next;
  }
}

template <typename T>
size_t LinkedList<T>::size() const {
  return count_;
}

template <typename T>
void LinkedList<T>::push(T* item) {
  Cell* prev = NULL;
  Cell* curr = head_;
  while (curr != NULL) {
    prev = curr;
    curr = curr->next;
  }

  Cell* newCell = new Cell();
  newCell->next = NULL;
  newCell->item = item;

  if (prev == NULL) {
    head_ = newCell;
  } else {
    prev->next = newCell;
  }

  count_++;
}

#endif  // UTIL_LINKEDLIST_H_
