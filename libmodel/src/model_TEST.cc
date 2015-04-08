/*
 * Copyright (c) 2014, Joe Example
 */
#include "model/Vehicle.h"
#include "model/Truck.h"
#include "model/Car.h"

#include "gtest/gtest.h"

TEST(model, all) {
  Vehicle* v1 = new Truck("ford", "f150", 2006, 6);
  Vehicle* v2 = new Car("honda", "accord", 1989, 22);
  delete v1;
  delete v2;
}
