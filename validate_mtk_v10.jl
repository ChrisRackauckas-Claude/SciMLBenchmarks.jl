# Simple validation script for ModelingToolkit v10 compatibility 
using ModelingToolkit, StaticArrays

println("Testing ModelingToolkit v10 @named macro compatibility...")

@independent_variables t
@variables y(t)[1:2] 
y = collect(y)
D = Differential(t)

# Test the @named macro pattern used in the fixed code
try
    @named test_sys = let
        test_eqs = [D(y[1]) ~ -y[1], D(y[2]) ~ y[1] - 2*y[2]]
        complete(ODESystem(test_eqs, t))
    end
    
    println("✓ @named macro with complete(ODESystem(eqs, t)) works!")
    println("✓ System name: ", nameof(test_sys))
    
    # Test problem creation
    using OrdinaryDiffEq
    prob = ODEProblem{false}(test_sys, y .=> 1.0, (0, 10.0))
    println("✓ ODEProblem creation successful!")
    
    # Test solving
    sol = solve(prob, Tsit5(), abstol=1e-6, reltol=1e-6)
    println("✓ Problem solving successful!")
    
    println("\nAll ModelingToolkit v10 compatibility tests passed! 🎉")
    
catch e
    println("❌ Error: ", e)
    rethrow(e)
end