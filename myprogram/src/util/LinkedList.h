/*
 * Copyright (c) 2014, Joe Example
 */
#ifndef UTIL_LINKEDLIST_H_
#define UTIL_LINKEDLIST_H_

#include <cstddef>

struct Cell {
  Cell* next;
  void* item;
};

template <typename T>
class LinkedList {
 public:
  LinkedList();
  ~LinkedList();
  size_t size() const;
  void push(T* item);

 private:
  Cell* head_;
  size_t count_;
};

#include "LinkedList.tcc"

#endif  // UTIL_LINKEDLIST_H_
