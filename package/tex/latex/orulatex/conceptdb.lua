-- This file contains the database of mathematical concepts

-- FOUNDATIONAL concepts. These concepts are considered fundamental in the context of the current study.
-- NOTE: Concepts considered foundational are subjective and should be changed depending on the course.

addition = "addition"
subtraction = "subtraction"
multiplication = "multiplication"
division = "division"
exponent = "exponent"
radical = "radical"
orderofoperations = "order of operations"
measurement = "measurement"
ordering = "ordering"
recursion = "recursion"

-- NON-FOUNDATIONAL concepts. These concepts are considered to be dependent on the above FOUNDATIONAL concepts.

mean 				= {"mean",orderofoperations,addition,division}
median_odd 			= {"median",ordering}
median_even 		= {"median",ordering,mean}
factoring 			= {"factoring",division}
reducing			= {"reducing",factoring}
fraction_to_decimal = {"fraction to decimal",division}
decimal_to_fraction = {"decimal to fraction",reducing}