#include "car.h"

Car::Car(std::string _make, std::string _model,
             int _year, int _mpg)
    : Vehicle(_make, _model, _year), mpg_(_mpg) {}

Car::~Car() {}

int Car::mpg() const {
  return mpg_;
}

void Car::mpgIs(int _mpg) {
  mpg_ = _mpg;
}
