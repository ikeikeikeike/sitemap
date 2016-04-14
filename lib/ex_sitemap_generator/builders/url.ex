defmodule ExSitemapGenerator.Builders.Url do
  import XmlBuilder

  def to_xml(link, opts \\ []) do
    elms =
      element(:url, [
        element(:loc,         link),
        element(:lastmod,     opts[:lastmod]),
        element(:expires,     opts[:expires]),
        element(:changefreq,  opts[:changefreq]),
        element(:priority,    opts[:priority]),
      ])

    if opts[:mobile],     do: elms = append_last(elms, mobile())
    if opts[:geo],        do: elms = append_last(elms, geo(opts[:geo]))
    if opts[:news],       do: elms = append_last(elms, news(opts[:news]))
    if opts[:pagemap],    do: elms = append_last(elms, pagemap(opts[:pagemap]))
    if opts[:images],     do: elms = append_last(elms, images([opts[:images]]))
    if opts[:videos],     do: elms = append_last(elms, videos([opts[:videos]]))
    if opts[:alternates], do: elms = append_last(elms, alternates([opts[:alternates]]))

    elms
  end

  defp append_last(elements, element) do
    combine = elem(elements, 2) ++ [element]

    elements
    |> Tuple.delete_at(2)
    |> Tuple.append(combine)
  end

  defp news(data) do
    element(:"news:news", [
      element(:"news:publication", [
        element(:"news:name",             data[:publication_name]),
        element(:"news:language",         data[:publication_language]),
      ]),
      element(":news:title",              data[:title]),
      element(":news:access",             data[:access]),
      element(":news:genres",             data[:genres]),
      element(":news:keywords",           data[:keywords]),
      element(":news:stock_tickers",      data[:stock_tickers]),
      element(":news:publication_date",   data[:publication_date]),
    ])
  end

  defp images(list, elements \\ [])
  defp images([], elements), do: elements
  defp images([data|tail], elements) do
    elm =
      element(:"image:image", [
        element(:"image:loc",             data[:loc]),
        element(:"image:title",           data[:title]),
        element(:"image:license",         data[:license]),
        element(:"image:caption",         data[:caption]),
        element(:"image:geo_location",    data[:geo_location]),
      ])

    images(tail, elements ++ [elm])
  end

  defp videos(list, elements \\ [])
  defp videos([], elements), do: elements
  defp videos([data|tail], elements) do
    elm =
      element(:"video:video", [
        element(:"video:title",           data[:title]),
        element(:"video:description",     data[:description]),

        # TODO: Elase nil when this statement returns that.
        (if data[:player_loc] do
          attrs = %{allow_embed: data[:allow_embed]}
          if data[:autoplay], do: attrs = Map.put(attrs, :autoplay, data[:autoplay])
          element(:"video:player_loc", attrs, data[:player_loc])
        end),
        element(:"video:content_loc",     data[:content_loc]),
        element(:"video:thumbnail_loc",   data[:thumbnail_loc]),
        element(:"video:gallery_loc", %{title: data[:gallery_title]}, data[:gallery_loc]),

        element(:"video:price", video_price_attrs(data), data[:price]),
        element(:"video:rating",          data[:rating]),
        element(:"video:duration",        data[:duration]),
        element(:"video:view_count",      data[:view_count]),

        element(:"video:expiration_date", data[:expiration_date]),
        element(:"video:publication_date",data[:publication_date]),

        Enum.map(data[:tags] || [], &(element(:"video:tag", &1))),
        element(:"video:tag",             data[:tag]),
        element(:"video:category",        data[:category]),

        element(:"video:family_friendly", data[:family_friendly]),

        # TODO: Elase nil when this statement returns that.
        (if data[:uploader] do
          attrs = %{}
          if data[:uploader_info], do: attrs = %{info: data[:uploader_info]}
          element(:"video:uploader", attrs, data[:uploader])
        end),

        element(:"video:live", data[:live]),
        element(:"video:requires_subscription", data[:requires_subscription]),
      ])

    videos(tail, elements ++ [elm])
  end

  defp video_price_attrs(data) do
    attrs = %{}
    attrs = Map.put attrs, :currency,     data[:price_currency]
    attrs = Map.put attrs, :type,         data[:price_type]
    attrs = Map.put attrs, :resolution,   data[:price_resolution]
    attrs
  end

  defp alternates(list, elements \\ [])
  defp alternates([], elements), do: elements
  defp alternates([data|tail], elements) do
    rel = if data[:nofollow], do: "alternate nofollow", else: "alternate"

    attrs = %{rel: rel, href: data[:href]}
    attrs = Map.put attrs, :hreflang, data[:lang]
    attrs = Map.put attrs, :media, data[:media]

    alternates(tail, elements ++ [element(:"xhtml:link", attrs)])
  end

  defp geo(data) do
    element(:"geo:geo", [
      element(:"geo:format", data[:format])
    ])
  end

  defp mobile do
    element(:"mobile:mobile")
  end

  defp pagemap(data) do
    element(:PageMap, Enum.map(data[:pagemap][:dataobjects] || [], fn(obj) ->
      element(:DataObject, %{type: obj[:type], id: obj[:id]}, Enum.map(obj[:attributes] || [], fn(attr) ->
        element(:Attribute, %{name: attr[:name]}, attr[:value])
      end))
    end))
  end

end
