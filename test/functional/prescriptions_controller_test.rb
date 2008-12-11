require File.dirname(__FILE__) + '/../test_helper'

class PrescriptionsControllerTest < Test::Unit::TestCase
  fixtures :drug, :orders, :drug_order, :order_type, :patient, :person, :encounter_type,
           :concept, :concept_name, :concept_class

  def setup  
    @controller = PrescriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
  end

  context "Prescriptions controller" do  
    should "provide the current list of orders for the patient" do
      logged_in_as :mikmck do
        get :index, {:patient_id => patient(:evan).patient_id} 
        assert_response :success
      end  
    end
    
    should "provide a form for creating a new prescription" do
      logged_in_as :mikmck do
        get :new, {:patient_id => patient(:evan).patient_id}
        assert_response :success
        assert_equal assigns(:patient), patient(:evan)
      end  
    end  

    should "lookup the set of generic drugs based on matching drugs to concepts" do
      logged_in_as :mikmck do
        get :generics, {:patient_id => patient(:evan).patient_id, :search_string => ''}
        assert_response :success
        assert_contains assigns(:drug_concepts), concept(:nitrous_oxide)
      end            
    end
    
    should "not lookup generic drugs which have no corresponding fomulation" do
      logged_in_as :mikmck do
        get :generics, {:patient_id => patient(:evan).patient_id, :search_string => ''}
        assert_response :success
        assert_does_not_contain assigns(:drug_concepts), concept(:diazepam)
      end            
    end    

    should "filter the set of generic drugs based on the search" 

    should "lookup the set of formulations that match a specific generic drug name" do
      logged_in_as :mikmck do
        get :formulations, {:patient_id => patient(:evan).patient_id, :search_string => '', :generic => 'NITROUS OXIDE'}
        assert_response :success
        assert_contains assigns(:drugs).map(&:name), drug(:laughing_gas_600).name
        assert_contains assigns(:drugs).map(&:name), drug(:laughing_gas_1000).name
      end                
    end

    should "filter the set of formulations based on the search" 
    
    should "handle dosages"
    should "handle create"
    should "handle print"
  end  
end