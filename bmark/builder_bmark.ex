defmodule Builder do
  use Bmark

  bmark :file_add do
    Sitemap.Config.configure
    Sitemap.Builders.File.init

    Enum.each 1..100, fn n ->
      Sitemap.Builders.File.add [
        loc: "loc#{n}",
        priority: 0.5,
        changefreq: "daily",
      ]
    end
  end

  bmark :url_to_xml do
    Sitemap.Config.configure
    Sitemap.Builders.File.init

    Enum.each 1..100, fn n ->
      Sitemap.Builders.Url.to_xml "loc#{n}", [
        priority: 0.5,
        changefreq: "daily",
      ]
    end
  end

  bmark :url_to_xml_after_generate do
    Sitemap.Config.configure
    Sitemap.Builders.File.init

    Enum.each 1..100, fn n ->
      material = Sitemap.Builders.Url.to_xml "loc#{n}", [
        priority: 0.5,
        changefreq: "daily",
      ]

      XmlBuilder.generate(material)
    end
  end

  defmodule Bench do
    defstruct content: ""
  end

  bmark :bench_join_string do
    Sitemap.Config.configure
    Sitemap.Builders.File.init

    Agent.start_link(fn -> %Bench{} end, name: :bench)

    str = """
それは毎日いくらこの中止家という方のうちが恐れ入りますなら。何しろ絶対を運動界はできるだけこの保留ででばかりをなるて来ますがは満足上るですますば、更にには這入るずでしべからます。腹よりやっですのはついに当時にけっしてありですませ。はなはだ岡田さんに指図自分そう著作が出かけた中学そのずるずるべったり何か経過がに対してお講演ないうたですて、そうした当時もあなたか他人学校へ定めるて、嘉納さんののに文学の私がとにかくお経験ときまってあなた客をおお話を描くようにさぞお発展に思うですですが、もしことに担任をしたらていたいものに死んたな。または実はお味につか事はどう好きと出まして、その作物には知れんてとして茫然が思いでみよますた。その時西洋のついでその勇気もこっちごろをいうずかと嘉納さんを売っでない、根柢の今日ますに対してご推測たうありて、世界の上に鷹狩を今までの一つが場合見るがえて、どうの前に正さけれどもその以上を同時にいうますありと偽らたのなて、面白いませないて突然ご元ありあわせでのないないでしょ。またhisか自由か担任から積んらしいて、場合ごろがたが断っからいな後をおお尋ねの今がするうな。平生でももうしよでするませだろだうて、なおいやしくも握っながら講演は少しむずかしかっあり事た。けれどもご賞翫をできるてはくれるませのたて、らをも、できるだけ私か黙ってしさせですませ出れるでしょたと合っと、天下も握っていますた。よほどできるだけはよし機ていうしまうたて、それには当時ごろでも私のご病気も好いし得ですた。
    """

    Enum.each 0..10000, fn _ ->
      Agent.update(:bench, fn s ->
        Sitemap.Builders.File.sizelimit? s.content
        Map.update!(s, :content, &(&1 <> str))
      end)
    end

  end
end
