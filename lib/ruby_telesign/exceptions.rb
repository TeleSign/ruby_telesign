# The **exceptions** module contains exception classes for handling the error
# conditions that can be thrown by procedures in the **api** module.

# __author__ = "Jeremy Cunningham, Michael Fox, and Radu Maierean"
# __copyright__ = "Copyright 2012, TeleSign Corp."
# __credits__ = ["Jeremy Cunningham", "Radu Maierean", "Michael Fox", "Nancy Vitug", "Humberto Morales"]
# __license__ = "MIT"
# __maintainer__ = "Jeremy Cunningham"
# __email__ = "support@telesign.com"
# __status__ = ""


class TelesignError < ::StandardError
  # """
  # The **exceptions** base class.

  # .. list-table::
  #    :widths: 5 30
  #    :header-rows: 1

  #    * - Attributes
  #      -
  #    * - `data`
  #      - The data returned by the service, in a dictionary form.
  #    * - `http_response`
  #      - The full HTTP Response object, including the HTTP status code, headers, and raw returned data.

  # """

  def initialize data, http_response
    @errors = data["errors"]
    @headers = http_response.headers
    @status = http_response.status_code
    @data = http_response.text
    @raw_data = http_response.text
  end

  def to_s
    @errors.inject(''){|ret, x| ret += "%s\n" % x["description"] }
  end
end


class AuthorizationError < TelesignError
  # """
  # Either the client failed to authenticate with the REST API server, or the service cannot be executed using the specified credentials.

  # .. list-table::
  #    :widths: 5 30
  #    :header-rows: 1

  #    * - Attributes
  #      -
  #    * - `data`
  #      - The data returned by the service, in a dictionary form.
  #    * - `http_response`
  #      - The full HTTP Response object, including the HTTP status code, headers, and raw returned data.

  # """

  def initialize data, http_response
    super
  end
end

class ValidationError < TelesignError
  # """
  # The submitted data failed the intial validation, and the service was not executed.

  # .. list-table::
  #    :widths: 5 30
  #    :header-rows: 1

  #    * - Attributes
  #      -
  #    * - `data`
  #      - The data returned by the service, in a dictionary form.
  #    * - `http_response`
  #      - The full HTTP Response object, including the HTTP status code, headers, and raw returned data.

  # """

  def initialize data, http_response
    super
  end
end

