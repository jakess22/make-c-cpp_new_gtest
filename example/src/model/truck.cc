#include "truck.h"

Truck::Truck(std::string _make, std::string _model,
             int _year, int _bedLength)
    : Vehicle(_make, _model, _year), bedLength_(_bedLength) {}

Truck::~Truck() {}

int Truck::bedLength() const {
  return bedLength_;
}

void Truck::bedLengthIs(int _bedLength) {
  bedLength_ = _bedLength;
}
