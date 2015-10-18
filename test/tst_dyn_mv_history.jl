
#-----------------------------------------------------------

msg("DynMultivalueHistory: Basic functions")

_history = DynMultivalueHistory()

function f(i, b; muh=10)
  @test b == "yo"
  @test muh == .3
  i
end

@test_throws ArgumentError push!(_history, :myf, -1, f(10, "yo", muh = .3))

numbers = collect(1:2:100)
for i = numbers
  @test push!(_history, :myf, i, f(i + 1, "yo", muh = .3)) == i + 1
  if i % 11 == 0
    @test push!(_history, :myint, i, i - 1) == i - 1
  end
end

@test_throws ArgumentError push!(_history, :myf, 200, "test")

@test first(_history, :myf) == (1, 2)
@test last(_history, :myf) == (99, 100)
@test first(_history, :myint) == (11, 10)
@test last(_history, :myint) == (99, 98)

for (i, v) in enumerate(_history, :myf)
  @test in(i, numbers)
  @test i + 1 == v
end

for (i, v) in enumerate(_history, :myint)
  @test in(i, numbers)
  @test i % 11 == 0
  @test i - 1 == v
end

a1, a2 = get(_history, :myf)
@test typeof(a1) <: Vector && typeof(a2) <: Vector
@test length(a1) == length(a2) == length(numbers) == length(_history, :myf)
@test a1 + 1 == a2

@test_throws ArgumentError push!(_history, :myf, 10, f(10, "yo", muh = .3))
@test_throws KeyError enumerate(_history, :sign)
@test_throws KeyError length(_history, :sign)

#-----------------------------------------------------------

msg("DynMultivalueHistory: Storing arbitrary types")

_history = DynMultivalueHistory(QueueUnivalueHistory, UInt8)

for i = 1:100
  @test push!(_history, :mystring, i % UInt8, string("i=", i + 1)) == string("i=", i+1)
  @test push!(_history, :myfloat, i % UInt8, Float32(i + 1)) == Float32(i+1)
end

a1, a2 = get(_history, :mystring)
@test typeof(a1) <: Vector{UInt8}
@test typeof(a2) <: Vector{ASCIIString}

a1, a2 = get(_history, :myfloat)
@test typeof(a1) <: Vector{UInt8}
@test typeof(a2) <: Vector{Float32}
