/*
 * Copyright (c) 2014, Joe Example
 */
#include <gtest/gtest.h>

#include "model/Truck.h"
#include "model/Vehicle.h"

TEST(TruckTest, test) {
  Truck t("Ford", "F150", 1996, 5);
  ASSERT_EQ(t.make(), "Ford");
  ASSERT_EQ(t.model(), "F150");
  ASSERT_EQ(t.year(), 1996);
  ASSERT_EQ(t.bedLength(), 5);

  Vehicle* vehicle = dynamic_cast<Vehicle*>(&t);
  ASSERT_FALSE(vehicle == NULL);
}
