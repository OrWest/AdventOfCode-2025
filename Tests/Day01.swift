import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L499
    R14
    L82
    L998
    """

  @Test func testPart01() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part1()) == "3")
  }

  @Test func testPart02() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part2()) == "20")
  }
}
