create type custom_data_type as (
id int,
name varchar(50),
score decimal(5,2),
create_time timestamp
);
 
create or replace function custom_data_type_demo(p_order_unit_array varchar[],p_goods_array int[])
returns custom_data_type[] as $$
declare
	v_order_unit_array varchar[] := array['a','b','c']::varchar[];
	v_goods_array int[] := array[60.56,82.12,95.32]::int[];
	v_tmp_result custom_data_type;
	v_result_array custom_data_type[];
	v_index int := 0;
	v_order varchar(100);
	v_goods int;
begin
	if p_order_unit_array is not null then
		v_order_unit_array := p_order_unit_array;
	end if;
 
	if p_goods_array is not null then
		v_goods_array := p_goods_array;
	end if;
 
	raise notice '-------1---------';
	<<order_label>> foreach v_order in array v_order_unit_array loop
		<<goods_label>> foreach v_goods in array v_goods_array loop
			v_tmp_result.id = v_index*round(random()*10);
			v_tmp_result.name = v_order;
			v_tmp_result.score = v_goods;
			v_tmp_result.create_time = current_timestamp;
		end loop goods_label;
		raise notice '-------a---------';
		v_result_array[v_index] = v_tmp_result;
		v_index := v_index + 1;
	end loop order_label;
	raise notice '-------2---------';
	return v_result_array;
exception when others then
	raise exception 'error happen(%)',sqlerrm;
end;
$$ language plpgsql;
 
select custom_data_type_demo(null,null);