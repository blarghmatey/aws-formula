{% set security_groups = salt['pillar.get']('aws:security_groups', []) %}

{% for group in security_groups %}
{{ group.name }}
  boto_secgroup.present:
    - name: {{ group.name }}
    - description: {{ group.description }}
    - rules:
        {% for rule in group.rules %}
        - {{ rule }}
        {% endfor %}
    {% if group.get('vpc_id', None) %}
    - vpc_id: {{ group.vpc_id }}
    {% endif %}
    - region: {{ salt['pillar.get']('aws:region', 'us-east-1') }}
    - keyid: {{ salt['pillar.get']('aws:key', None) }}
    - key: {{ salt['pillar.get']('aws:secret_key', None) }}
{% endfor %}