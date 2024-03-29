module ApplicationHelper

	def avatar_url(user, width = 28)
		image_tag(user.avatar_url || "https://api.dicebear.com/6.x/identicon/svg?seed=#{user.name}&backgroundColor=d1d4f9&radius=50",
				  class: "ui mini avatar image",
				  alt: "avatar",
				  style: "width: #{width}px !important"
		)
	end

	def markdown(content)
		options = [:escape_html, :safe_links_only, :hard_wrap, :autolink, :no_intra_emphasis, :strikethrough]
		Markdown.new(content, *options).to_html.html_safe
	end

end
