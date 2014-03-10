/*
 * Copyright (c) 2014, Joe Example
 */
#ifndef MODEL_CAR_H_
#define MODEL_CAR_H_

#include <string>

#include "model/vehicle.h"

class Car : public Vehicle {
 public:
  Car(std::string _make, std::string _model,
        int _year, int _mpg);
  virtual ~Car();

  int mpg() const;
  void mpgIs(int _mpg);

 private:
  int mpg_;
};

#endif  // MODEL_CAR_H_
