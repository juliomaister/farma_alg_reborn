module ExercisesHelper
  # 'CodeRayify' class implementation taken from
  # http://allfuzzy.tumblr.com/post/27314404412/markdown-and-code-syntax-highlighting-in-ruby-on
  #class CodeRayify < Redcarpet::Render::HTML
  #  def block_code(code, language)
  #    CodeRay.scan(code, language).div(:line_numbers => :table)
  #  end
  #end

  # Display in markdown ("prettified").
  def markdown(text)
    #coderayified = CodeRayify.new(no_images: true)

    extensions = { hard_wrap: true, filter_html: true, autolink: true,
                   no_intraemphasis: true, fenced_code_blocks: true,
                   tables: true, superscript: true }

    # markdown = Redcarpet::Markdown.new(coderayified, extensions)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  # Pluralize question text.
  def pluralize_questions(count)
    return "#{count} questões cadastradas" if count >= 0
    "#{count} questão cadastrada"
  end

  # Returns a span tag with the right label.
  def question_status(question, team)
    if question.answered_by_user?(current_user, team: team, only_correct: true)
      '<span class="badge bg-green">Correta</span>'
    elsif question.answered_by_user?(current_user, team: team)
      '<span class="badge bg-red text-center" style="width=70px">Errada</span>'
    else
      '<span class="badge bg-gray">Sem resposta</span>'
    end
  end

  # Returns a width property filled according user progress
  # (in the current template, progressbar is filled according the
  # width property, so it must be created dynamically).
  def progress(exercise, team)
    "width: #{exercise.user_progress(current_user, team)}%"
  end
end
