{% from "aws/map.jinja" import aws with context %}

{% set scale_groups = salt['pillar.get']('aws:autoscale:groups', []) %}
{% set aws_key = salt['pillar.get']('aws:key', None) %}
{% set aws_secret_key = salt['pillar.get']('aws:secret_key', None) %}

{% for group in scale_groups %}

{% set availability_zones = group.get('availability_zones', []) %}
{% set default_cooldown = group.get('default_cooldown', 1800) %}
{% set desired_capacity = group.desired_capacity %}
{% set group_name = group.name %}
{% set health_check_type = group.get('health_check_type', 'ELB') %}
{% set health_check_period = group.get('health_check_period', 300) %}
{% set launch_config_name = group.launch_config.name %}
{% set launch_config = group.get('launch_config', {}) %}
{% set load_balancers = group.get('load_balancers', []) %}
{% set max_size = group.max_size %}
{% set min_size = group.min_size %}
{% set region = group.get('region', 'us-east-1') %}
{% set scaling_policies = group.get('scaling_policies', []) %}
{% set suspended_processes = group.get('suspended_processes', []) %}
{% set termination_policies = group.get('termination_policies', 'ClosestToNextInstanceHour') %}
{% set vpc_zone_identifiers = group.get('vpc_zone_identifiers', []) %}
create_autoscale_{{ group_name }}:
  boto_asg.present:
    - name: {{ group_name }}
    - launch_config_name: {{ launch_config_name }}
    - keyid: {{ aws_key }}
    - key: {{ aws_secret_key }}
    - availability_zones:
        {% for zone in availability_zones %}
        - {{ zone }}
        {% endfor %}
    - min_size: {{ min_size }}
    - max_size: {{ max_size }}
    {% if launch_config %}
    - launch_config: {{ launch_config }}
    {% endif %}
    {% if load_balancers %}
    - load_balancers:
        {% for lb in load_balancers %}
        - {{ lb }}
        {% endfor %}
    {% endif %}
    {% if default_cooldown %}
    - default_cooldown: {{ default_cooldown }}
    {% endif %}
    {% if desired_capacity %}
    - desired_capacity: {{ desired_capacity }}
    {% endif %}
    {% if health_check_type %}
    - health_check_type: {{ health_check_type }}
    {% endif %}
    {% if health_check_period %}
    - health_check_period: {{ health_check_period }}
    {% endif %}
    {% if launch_config %}
    - launch_config: {{ launch_config }}
    {% endif %}
    {% if region %}
    - region: {{ region }}
    {% endif %}
    {% if scaling_policies %}
    - scaling_policies:
        {% for policy in scaling_policies %}
        - {{ policy }}
        {% endfor %}
    {% endif %}
    {% if suspended_processes %}
    - suspended_processes:
        {% for process in suspended_processes %}
        - {{ process }}
        {% endfor %}
    {% endif %}
    {% if termination_policies %}
    - termination_policies:
        {% for policy in termination_policies %}
        - {{ policy }}
        {% endfor %}
    {% endif %}
    {% if vpc_zone_identifiers %}
    - vpc_zone_identifier:
        {% for identifier in vpc_zone_identifiers %}
        - {{ identifier }}
        {% endfor %}
    {% endif %}

{% endfor %}