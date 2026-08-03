local Calculator = {}

function Calculator.Add(a, b)
	local result = a + b
	return result
end

function Calculator.Sub(a, b)
	local result = a - b
	return result
end

function Calculator.Mult(a, b)
	local result = a * b
	return result
end

function Calculator.Div(a, b)
	local result = a / b
	return result
end


return Calculator
