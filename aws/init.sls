{% from "aws/map.jinja" import aws with context %}

aws_pkg_reqs:
  pkg.installed:
    - pkgs: {{ aws.pkgs }}

{% for pip_pkg in aws.pip_pkgs %}
{{ pip_pkg }}:
  pip.installed:
    - require:
        - pkg: aws_pkg_reqs
{% endfor %}