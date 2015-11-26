module SessionsHelper
    # Logs in the given user.
    def log_in(author)
        session[:author_id] = author.id
    end
    # Remembers a user in a persistent session.
    def remember(author)
        author.remember
        cookies.permanent.signed[:author_id] = author.id
        cookies.permanent[:remember_token] = author.remember_token
    end
    
    # Returns true if the given user is the current user.
    def current_author?(author)
        author == current_author
    end
  
    # Returns the user corresponding to the remember token cookie.
    def current_author
        if (author_id = session[:author_id])
          @current_author ||= Author.find_by(id: author_id)
        elsif (author_id = cookies.signed[:author_id])
            author = Author.find_by(id: author_id)
            if author && author.authenticated?(cookies[:remember_token])
                log_in author
                @current_author = author
            end
        end
    end
    def logged_in?
        !current_author.nil?
    end
    # Forgets a persistent session.
    def forget(author)
        author.forget
        cookies.delete(:author_id)
        cookies.delete(:remember_token)
    end
    def log_out
        forget(current_author)
        session.delete(:author_id)
        @current_author = nil
    end
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end

    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.url if request.get?
    end
end
