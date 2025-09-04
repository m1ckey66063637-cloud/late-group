import java.nio.file.{Files, Paths}
import scala.util.Try

object Main {
  def main(args: Array[String]): Unit = {
    val filePath = "/Users/voldemarq/late-group/challenge_day4/fulldata/data1.json"
    val lines = Try(scala.io.Source.fromFile(filePath).getLines().toList).getOrElse(List())
    val outputLines = lines.zipWithIndex.map {
      case (line, 0) => s"$line,Comments"
      case (line, _) =>
        val parts = line.split(",")
        if (parts.length < 9) line // skip invalid lines (need name + 6 skills + summary + evaluation)
        else {
          val summary = parts(7)
          val evaluation = parts(8).toFloat
          val comments = (summary, evaluation) match {
            case ("super", e) if e >= 3 => "Excellent"  
            case ("super", _) => "Good but inconsistent"
            case (_, e) if e >= 2 => "Promising"  
            case _ => "Needs Improvement"
          }
          s"$line,$comments"
        }
    }

    Files.write(Paths.get("/Users/voldemarq/late-group/challenge_day4/testdata/data7.txt"), outputLines.mkString("\n").getBytes)
  }
}
