/*
 * Copyright (c) 2014, Joe Example
 */
#ifndef MODEL_TRUCK_H_
#define MODEL_TRUCK_H_

#include <string>

#include "model/Vehicle.h"

class Truck : public Vehicle {
 public:
  Truck(std::string _make, std::string _model,
        int _year, int _bedLength);
  virtual ~Truck();

  int bedLength() const;
  void bedLengthIs(int _bedLength);

 private:
  int bedLength_;
};

#endif  // MODEL_TRUCK_H_
