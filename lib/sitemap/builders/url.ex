defmodule Sitemap.Builders.Url do
  alias Sitemap.Funcs
  alias Sitemap.Config
  alias Sitemap.Consts
  import XmlBuilder

  def to_xml(link, attrs \\ []) do
    elms =
      element(
        :url,
        Funcs.eraser([
          element(:loc, Path.join(Config.get().host, link || "")),
          element(
            :lastmod,
            Funcs.iso8601(Keyword.get_lazy(attrs, :lastmod, fn -> Funcs.iso8601() end))
          ),
          element(:expires, attrs[:expires]),
          element(:changefreq, attrs[:changefreq]),
          element(:priority, attrs[:priority])
        ])
      )

    elms = ifput(attrs[:mobile], elms, &append_last(&1, mobile()))
    elms = ifput(attrs[:geo], elms, &append_last(&1, geo(attrs[:geo])))
    elms = ifput(attrs[:news], elms, &append_last(&1, news(attrs[:news])))
    elms = ifput(attrs[:pagemap], elms, &append_last(&1, pagemap(attrs[:pagemap])))
    elms = ifput(attrs[:images], elms, &append_last(&1, images(attrs[:images])))
    elms = ifput(attrs[:videos], elms, &append_last(&1, videos(attrs[:videos])))
    elms = ifput(attrs[:alternates], elms, &append_last(&1, alternates(attrs[:alternates])))
    elms
  end

  defp ifput(bool, elms, fun) do
    if bool do
      fun.(elms)
    else
      elms
    end
  end

  defp append_last(elements, element) do
    combine = elem(elements, 2) ++ [element]

    elements
    |> Tuple.delete_at(2)
    |> Tuple.append(combine)
  end

  defp news(data) do
    element(
      :"news:news",
      Funcs.eraser([
        element(
          :"news:publication",
          Funcs.eraser([
            element(:"news:name", data[:publication_name]),
            element(:"news:language", data[:publication_language])
          ])
        ),
        element(:"news:title", data[:title]),
        element(:"news:access", data[:access]),
        element(:"news:genres", data[:genres]),
        element(:"news:keywords", data[:keywords]),
        element(:"news:stock_tickers", data[:stock_tickers]),
        element(:"news:publication_date", Funcs.iso8601(data[:publication_date]))
      ])
    )
  end

  defp images(list, elements \\ [])
  defp images([], elements), do: elements

  defp images([{_, _} | _] = list, elements) do
    # Make sure keyword list
    images([list], elements)
  end

  defp images([data | tail], elements) do
    elm =
      element(
        :"image:image",
        Funcs.eraser([
          element(:"image:loc", data[:loc]),
          unless(is_nil(data[:title]), do: element(:"image:title", data[:title])),
          unless(is_nil(data[:license]), do: element(:"image:license", data[:license])),
          unless(is_nil(data[:caption]), do: element(:"image:caption", data[:caption])),
          unless(is_nil(data[:geo_location]),
            do: element(:"image:geo_location", data[:geo_location])
          )
        ])
      )

    images(tail, elements ++ [elm])
  end

  defp videos(list, elements \\ [])
  defp videos([], elements), do: elements

  defp videos([{_, _} | _] = list, elements) do
    # Make sure keyword list
    videos([list], elements)
  end

  defp videos([data | tail], elements) do
    elm =
      element(
        :"video:video",
        Funcs.eraser([
          element(:"video:title", data[:title]),
          element(:"video:description", data[:description]),
          if data[:player_loc] do
            attrs = %{allow_embed: Funcs.yes_no(data[:allow_embed])}

            attrs =
              ifput(
                data[:autoplay],
                attrs,
                &Map.put(&1, :autoplay, Funcs.autoplay(data[:autoplay]))
              )

            element(:"video:player_loc", attrs, data[:player_loc])
          end,
          element(:"video:content_loc", data[:content_loc]),
          element(:"video:thumbnail_loc", data[:thumbnail_loc]),
          element(:"video:duration", data[:duration]),
          unless(is_nil(data[:gallery_loc]),
            do: element(:"video:gallery_loc", %{title: data[:gallery_title]}, data[:gallery_loc])
          ),
          unless(is_nil(data[:rating]), do: element(:"video:rating", data[:rating])),
          unless(is_nil(data[:view_count]), do: element(:"video:view_count", data[:view_count])),
          unless(is_nil(data[:expiration_date]),
            do: element(:"video:expiration_date", Funcs.iso8601(data[:expiration_date]))
          ),
          unless(is_nil(data[:publication_date]),
            do: element(:"video:publication_date", Funcs.iso8601(data[:publication_date]))
          ),
          unless(is_nil(data[:tags]), do: Enum.map(data[:tags] || [], &element(:"video:tag", &1))),
          unless(is_nil(data[:tag]), do: element(:"video:tag", data[:tag])),
          unless(is_nil(data[:category]), do: element(:"video:category", data[:category])),
          unless(is_nil(data[:family_friendly]),
            do: element(:"video:family_friendly", Funcs.yes_no(data[:family_friendly]))
          ),
          unless is_nil(data[:restriction]) do
            attrs = %{relationship: Funcs.allow_deny(data[:relationship])}
            element(:"video:restriction", attrs, data[:restriction])
          end,
          unless is_nil(data[:uploader]) do
            attrs = %{}
            attrs = ifput(data[:uploader_info], attrs, &Map.put(&1, :info, data[:uploader_info]))
            element(:"video:uploader", attrs, data[:uploader])
          end,
          unless(is_nil(data[:price]),
            do: element(:"video:price", video_price_attrs(data), data[:price])
          ),
          unless(is_nil(data[:live]), do: element(:"video:live", Funcs.yes_no(data[:live]))),
          unless(is_nil(data[:requires_subscription]),
            do:
              element(:"video:requires_subscription", Funcs.yes_no(data[:requires_subscription]))
          )
        ])
      )

    videos(tail, elements ++ [elm])
  end

  defp video_price_attrs(data) do
    attrs = %{}
    attrs = Map.put(attrs, :currency, data[:price_currency])
    attrs = ifput(data[:price_type], attrs, &Map.put(&1, :type, data[:price_type]))
    attrs = ifput(data[:price_type], attrs, &Map.put(&1, :resolution, data[:price_resolution]))
    attrs
  end

  defp alternates(list, elements \\ [])
  defp alternates([], elements), do: elements

  defp alternates([{_, _} | _] = list, elements) do
    # Make sure keyword list
    alternates([list], elements)
  end

  defp alternates([data | tail], elements) do
    rel = if data[:nofollow], do: "alternate nofollow", else: "alternate"

    attrs = %{rel: rel, href: data[:href]}
    attrs = Map.put(attrs, :hreflang, data[:lang])
    attrs = Map.put(attrs, :media, data[:media])

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
    element(
      :PageMap,
      %{xmlns: Consts.schemas.pagemap},
      Enum.map(data[:dataobjects] || [], fn obj ->
        element(
          :DataObject,
          %{type: obj[:type], id: obj[:id]},
          Enum.map(obj[:attributes] || [], fn attr ->
            element(:Attribute, %{name: attr[:name]}, attr[:value])
          end)
        )
      end)
    )
  end
end
